// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import "bootstrap"
import flatpickr from "flatpickr";

document.addEventListener('turbolinks:load', () => {
  flatpickr(".datepicker", {});
});
