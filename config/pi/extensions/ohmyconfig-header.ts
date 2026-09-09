import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { VERSION } from "@earendil-works/pi-coding-agent";
import { truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";

const QUOTES = [
  "It's not a bug, it's an undocumented feature.",
  "There are only 10 types of people in the world: those who understand binary, and those who don't.",
  "Talk is cheap. Show me the code. – Linus Torvalds",
  "Any fool can write code that a computer can understand. Good programmers write code that humans can understand.",
  "First, solve the problem. Then, write the code. – John Johnson",
  "Experience is the name everyone gives to their mistakes. – Oscar Wilde",
  "Code is like humor. When you have to explain it, it’s bad. – Cory House",
  "Fix the cause, not the symptom. – Steve Maguire",
  "Make it work, make it right, make it fast. – Kent Beck",
  "Before software can be reusable it first has to be usable. – Ralph Johnson",
  "Simplicity is the soul of efficiency. – Austin Freeman",
  "Optimism is an occupational hazard of programming: feedback is the treatment. – Kent Beck",
  "The best error message is the one that never shows up. – Thomas Fuchs",
  "I'm not a great programmer; I'm just a good programmer with great habits. – Kent Beck",
  "Truth can only be found in one place: the code. – Robert C. Martin",
  "Programming isn't about what you know; it's about what you can figure out. – Chris Pine",
  "The only way to learn a new programming language is by writing programs in it. – Dennis Ritchie",
  "Sometimes it pays to stay in bed on Monday, rather than spending the rest of the week debugging Monday's code. – Dan Salomon",
  "Measuring programming progress by lines of code is like measuring airplane building progress by weight. – Bill Gates",
  "If debugging is the process of removing bugs, then programming must be the process of putting them in. – Edsger W. Dijkstra"
];

function generateMatrixLogo(theme: any): string[] {
  const PI_MASK = [
    "                                               ",
    "       ██████████████████████████████████      ",
    "      ████████████████████████████████████     ",
    "      █████    ██████          ██████          ",
    "               ██████          ██████          ",
    "               ██████          ██████          ",
    "               ██████          ██████          ",
    "               ██████          ██████          ",
    "            █████████          ██████          ",
    "           ████████            █████████       ",
    "                                               "
  ];

  const lines: string[] = [];
  
  for (let y = 0; y < PI_MASK.length; y++) {
    let currentLine = "";
    const row = PI_MASK[y];
    
    let isPiMode = false;
    let segment = "";
    
    for (let x = 0; x < row.length; x++) {
      const isPi = row[x] === "█";
      const char = Math.random() > 0.5 ? "1" : "0";
      
      if (isPi !== isPiMode) {
        if (segment.length > 0) {
          currentLine += isPiMode ? theme.fg("accent", segment) : theme.fg("dim", segment);
          segment = "";
        }
        isPiMode = isPi;
      }
      segment += char;
    }
    
    if (segment.length > 0) {
      currentLine += isPiMode ? theme.fg("accent", segment) : theme.fg("dim", segment);
    }
    
    lines.push(currentLine);
  }
  
  return ["", ...lines, ""];
}

function center(line: string, width: number): string {
  const pad = Math.max(0, Math.floor((width - visibleWidth(line)) / 2));
  return " ".repeat(pad) + truncateToWidth(line, width - pad, "");
}

export default function piCustomHeader(pi: ExtensionAPI) {
  pi.on("session_start", (_event, ctx) => {
    if (!ctx.hasUI) return;

    const randomQuote = QUOTES[Math.floor(Math.random() * QUOTES.length)];

    // Startup Header (Logo en grande)
    ctx.ui.setHeader((_tui, theme) => {
      // Generamos la matriz una sola vez al cargar para que no parpadee
      const logo = generateMatrixLogo(theme);

      return {
        render(width: number): string[] {
          const info = theme.fg("dim", `Pi Coding Agent v${VERSION}`);
          const help = theme.fg("muted", randomQuote);
          
          return [
            ...logo.map(line => center(line, width)),
            center(info, width),
            center(help, width),
            ""
          ];
        },
        invalidate() {},
      };
    });

    // Mini-header persistente
    ctx.ui.setWidget("pi-persistent-header", (_tui, theme) => ({
      render(width: number): string[] {
        const left = [
          theme.bg("selectedBg", theme.fg("searchMatchText", theme.bold(" π "))),
          " ",
          theme.fg("muted", ctx.cwd.replace(process.env.HOME ?? "", "~")),
        ].join("");
        
        const right = theme.fg("dim", ctx.model?.id ?? "no model selected");
        const gap = " ".repeat(Math.max(1, width - visibleWidth(left) - visibleWidth(right)));
        
        return [truncateToWidth(left + gap + right, width, "")];
      },
      invalidate() {},
    }));
  });
}
