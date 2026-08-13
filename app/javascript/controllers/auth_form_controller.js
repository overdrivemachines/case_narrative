import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["password", "passwordToggle", "submit", "submitLabel"];

  togglePassword() {
    const showing = this.passwordTarget.type === "text";

    this.passwordTarget.type = showing ? "password" : "text";
    this.passwordToggleTarget.setAttribute("aria-pressed", String(!showing));
    this.passwordToggleTarget.setAttribute("aria-label", showing ? "Show password" : "Hide password");
  }

  submit(event) {
    if (!this.element.checkValidity()) return;

    this.submitTarget.disabled = true;
    this.submitTarget.classList.add("is-loading");
    this.submitLabelTarget.textContent = "Signing in";

    // Native form submissions do not need this, but Turbo may cancel a request.
    event.target.addEventListener("turbo:submit-end", () => this.resetSubmit(), { once: true });
  }

  resetSubmit() {
    this.submitTarget.disabled = false;
    this.submitTarget.classList.remove("is-loading");
    this.submitLabelTarget.textContent = "Sign in";
  }
}
