// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import Rails from "@rails/ujs";

console.log("Rails UJS loaded:", Rails); // Vérifier si Rails est bien chargé
Rails.start();


import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"
