import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "../..");
const stateFile = path.join(
  process.env.XDG_CONFIG_HOME || path.join(process.env.HOME, ".config"),
  "ai.chile",
  "mode",
);
const modes = {
  godin: "Low intensity: be fast and pragmatic; report only the clearest safe cuts.",
  chakaloso: "Medium intensity: be focused and critical; verify relevant callers, references, and behavior before reporting.",
  chambeador: "High intensity: be exhaustive; inspect the whole repository and report every proven finding, while remaining report-only.",
};

function mode() {
  try {
    const value = fs.readFileSync(stateFile, "utf8").trim();
    return value === "off" || modes[value] ? value : "chakaloso";
  } catch {
    return "chakaloso";
  }
}

function saveMode(value) {
  fs.mkdirSync(path.dirname(stateFile), { recursive: true });
  fs.writeFileSync(stateFile, value);
}

function readCommand(file) {
  const content = fs.readFileSync(file, "utf8");
  const match = content.match(/^---\r?\n([\s\S]*?)\r?\n---\r?\n([\s\S]*)$/);
  if (!match) return null;
  const description = match[1].match(/^description:\s*(.+)$/m)?.[1]?.trim();
  return { description, template: match[2].trim() };
}

export default async function AiChilePlugin() {
  return {
    config: async (config) => {
      config.skills ??= {};
      config.skills.paths ??= [];
      const skills = path.join(root, "skills");
      if (!config.skills.paths.includes(skills)) config.skills.paths.push(skills);

      config.command ??= {};
      const commands = path.join(root, ".opencode", "command");
      for (const file of fs.readdirSync(commands).filter((name) => name.endsWith(".md"))) {
        const command = readCommand(path.join(commands, file));
        if (command) config.command[path.basename(file, ".md")] = command;
      }
    },
    "command.execute.before": async (input) => {
      if (input?.command !== "elchalan") return;
      const selected = String(input.arguments || "").trim().toLowerCase() || "chakaloso";
      if (selected === "off" || modes[selected]) saveMode(selected);
    },
    "experimental.chat.system.transform": async (_input, output) => {
      const selected = mode();
      if (selected !== "off") {
        output.system ??= [];
        output.system.push(
          `elchalan ${selected}: ${modes[selected]} Apply this overlay only to elmatamuertos and elmatachingaderas. It must not change elmatabichos behavior.`,
        );
      }
    },
  };
}
