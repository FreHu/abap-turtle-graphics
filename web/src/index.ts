// @ts-ignore
global.MonacoEnvironment = {
  globalAPI: true,
  getWorkerUrl: function (_moduleId: any, label: any) {
    if (label === "json") {
      return "./json.worker.bundle.js";
    }
    if (label === "typescript" || label === "javascript") {
      return "./ts.worker.bundle.js";
    }
    return "./editor.worker.bundle.js";
  },
};

import "./index.css";
import * as monaco from "monaco-editor";
import {config, Transpiler} from "@abaplint/transpiler";
import {ABAP} from "@abaplint/runtime";
import * as abaplint from "@abaplint/core";
import * as abapMonaco from "@abaplint/monaco";
import Split from "split-grid";

const reg = new abaplint.Registry(new abaplint.Config(JSON.stringify(config)));
abapMonaco.registerABAP(reg);

const filename = "file:///zfoobar.prog.abap";
const abapModel = monaco.editor.createModel(
  `WRITE '<svg width="150" height="150"><circle cx="50" cy="50" r="50"></circle></svg>'.`,
  "abap",
  monaco.Uri.parse(filename),
);
reg.addFile(new abaplint.MemoryFile(filename, ""));

Split({
  columnGutters: [
    {
      track: 1,
      element: document.getElementById("abap-editor-gutter"),
    },
    {
      track: 3,
      element: document.getElementById("js-editor-gutter"),
    },
  ],
});

const abapEditor = monaco.editor.create(document.getElementById("abap-editor-container"), {
  model: abapModel,
  theme: "vs-dark",
  minimap: {
    enabled: false,
  },
});

const jsEditor = monaco.editor.create(document.getElementById("js-editor-container"), {
  value: "js",
  theme: "vs-dark",
  minimap: {
    enabled: false,
  },
  language: "javascript",
});

function updateEditorLayouts() {
  abapEditor.layout();
  jsEditor.layout();
}

const observer = new MutationObserver(mutations => {
  for (const mutation of mutations) {
    if (mutation.attributeName === "style") {
      updateEditorLayouts();
    }
  }
});

observer.observe(document.getElementById("horizon"), {
  attributes: true,
  attributeFilter: [
    "style",
  ],
});

window.addEventListener("resize", updateEditorLayouts);

// see https://github.com/SimulatedGREG/electron-vue/issues/777
// see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/AsyncFunction
const AsyncFunction = new Function(`return Object.getPrototypeOf(async function(){}).constructor`)();

async function jsChanged() {
  const makeGlobal = "abap = abapLocal;\n";
  const js = makeGlobal + jsEditor.getValue();
  const output = document.getElementById("svg-container");
  try {
    abap.console.clear();
    try {
      const f = new AsyncFunction("abapLocal", js);
      await f(abap);
      output.innerHTML = abap.console.get();
    } catch(e) {
      showError("An error was thrown: " + e.toString());
    }
  } catch (error) {
    showError(error.message);
  }
}

async function abapChanged() {
  try {
    hideError();
    const contents = abapEditor.getValue();
    const file = new abaplint.MemoryFile(filename, contents);
    reg.updateFile(file);
    reg.parse();
    abapMonaco.updateMarkers(reg, abapModel);

    const res = await new Transpiler().runRaw([{filename, contents}]);
    jsEditor.setValue(res.objects[0].chunk.getCode() || "");
  } catch (error) {
    jsEditor.setValue("");
    showError(error);
  }
}

abapEditor.onDidChangeModelContent(abapChanged);
jsEditor.onDidChangeModelContent(jsChanged);
abapChanged();
abapEditor.focus();
const abap = new ABAP();

function showError(error: any) {
  const output = document.getElementById("error-banner");
  output.classList.remove("hidden");
  const errorDiv = document.getElementById("error-message");
  errorDiv.innerHTML = error.message;
  console.dir(error);
}

function hideError(){
  const output = document.getElementById("error-banner");
  output.classList.add("hidden");
}
