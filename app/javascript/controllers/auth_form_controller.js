import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["submit", "submitLabel"];
  static values = { submittingLabel: { type: String, default: "Working" } };

  connect() {
    if (this.hasSubmitLabelTarget) this.defaultSubmitLabel = this.submitLabelTarget.textContent;
  }

  togglePassword(event) {
    const toggle = event.currentTarget;
    const password = toggle.closest(".devise-input-wrap-password").querySelector("input");
    const showing = password.type === "text";

    password.type = showing ? "password" : "text";
    toggle.setAttribute("aria-pressed", String(!showing));
    toggle.setAttribute("aria-label", showing ? "Show password" : "Hide password");
  }

  submit(event) {
    this.element.classList.add("was-validated");

    if (!this.element.checkValidity()) {
      event.preventDefault();
      event.stopImmediatePropagation();
      return;
    }

    this.submitTarget.disabled = true;
    this.submitTarget.classList.add("is-loading");
    this.submitLabelTarget.textContent = this.submittingLabelValue;

    // Native form submissions do not need this, but Turbo may cancel a request.
    event.target.addEventListener("turbo:submit-end", () => this.resetSubmit(), { once: true });
  }

  resetSubmit() {
    this.submitTarget.disabled = false;
    this.submitTarget.classList.remove("is-loading");
    this.submitLabelTarget.textContent = this.defaultSubmitLabel;
  }
}
