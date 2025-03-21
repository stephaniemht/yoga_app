// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import Rails from "@rails/ujs";
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"

document.addEventListener("DOMContentLoaded", function () {
  const aboutSection = document.querySelector(".about-section");

  function checkVisibility() {
    const rect = aboutSection.getBoundingClientRect();
    if (rect.top < window.innerHeight - 100) {
      aboutSection.classList.add("visible");
    }
  }

  window.addEventListener("scroll", checkVisibility);
  checkVisibility(); // Vérifie dès le chargement de la page
});
