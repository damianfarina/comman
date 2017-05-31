(function(document, window) {
  'use strict';

  const storage = window.localStorage;

  document.addEventListener("turbolinks:load", function() {
    setupMenu();
  });

  function setupMenu() {
    const bodyElement = document.querySelector('body');
    const menuElement = document.querySelector('.site-header__menu');
    const sidebarOpenClass = 'layout__main-container-sidebar--open';

    if (storage.getItem('sidebar-open') === 'true') {
      bodyElement.classList.remove(sidebarOpenClass);
      bodyElement.classList.add(sidebarOpenClass);
    }

    menuElement.addEventListener('click', (param) => {
      bodyElement.classList.toggle(sidebarOpenClass);
      const sidebarIsOpen = bodyElement.classList.contains(sidebarOpenClass);
      storage.setItem('sidebar-open', sidebarIsOpen);
    });
  }

}(document, window));
