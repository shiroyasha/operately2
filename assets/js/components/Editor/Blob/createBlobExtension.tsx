import { Node } from "@tiptap/core";
import { EditableImageView } from "./EditableImageView";
import { ReactNodeViewRenderer } from "@tiptap/react";

export const createBlobExtension = (plugins: any[]) => {
  return Node.create({
    name: "blob",
    inline: true,
    group: "inline",
    draggable: true,

    addAttributes: () => ({
      src: {},
      alt: { default: null },
      title: { default: null },
      id: { default: null },
      status: { default: "uploading" },
      progress: { default: 0 },
    }),

    parseHTML: () => [
      {
        tag: "img[src]",
        getAttrs: (dom) => {
          if (typeof dom === "string") return {};
          const element = dom as HTMLImageElement;

          return {
            src: element.getAttribute("src"),
            title: element.getAttribute("title"),
            alt: element.getAttribute("alt"),
          };
        },
      },
    ],

    renderHTML: ({ HTMLAttributes }) => {
      return [
        "div",
        { class: "blob-container" },
        ["img", HTMLAttributes],
        ["div", { class: "footer" }, ["span", { class: "title" }, HTMLAttributes.alt]],
      ];
    },

    addNodeView: () => {
      return ReactNodeViewRenderer(EditableImageView);
    },

    addProseMirrorPlugins() {
      return plugins;
    },
  });
};
