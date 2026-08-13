import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["arrowUpRightIconTemplate", "tagListArrowIconTemplate"];

  connect() {
    // Hydrate lightweight server-rendered placeholders from shared SVG templates.
    this.replaceArrowUpRightIcons();
    this.replaceTagListArrowIcons();
  }

  // Replace every decorative up-right arrow placeholder used across the home page.
  replaceArrowUpRightIcons() {
    this.element.querySelectorAll("i.icon-arrow-up-right").forEach((icon) => {
      const svg = this.arrowUpRightIconTemplateTarget.content.firstElementChild.cloneNode(true);

      svg.classList.add("icon-arrow-up-right");
      svg.setAttribute("aria-hidden", "true");
      icon.replaceWith(svg);
    });
  }

  // Replace capability tag placeholders with the shared bent-arrow SVG.
  replaceTagListArrowIcons() {
    this.element.querySelectorAll("i.home-tag-list-arrow-icon").forEach((icon) => {
      const svg = this.tagListArrowIconTemplateTarget.content.firstElementChild.cloneNode(true);

      svg.classList.add("home-tag-list-arrow-icon");
      svg.setAttribute("aria-hidden", "true");
      icon.replaceWith(svg);
    });
  }
}
