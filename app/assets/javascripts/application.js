// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require turbo
//= require jquery
//= require jquery_ujs
//= require components
//= require_tree .

var tacticalModalResizeObserver = null;

function resizeTacticalModalFrame() {
  var frame = document.getElementById('tactical-modal-frame');
  if (!frame || !frame.contentWindow) return;

  try {
    var doc = frame.contentDocument || frame.contentWindow.document;
    if (!doc || !doc.body) return;

    var contentHeight = Math.max(
      doc.body.scrollHeight,
      doc.body.offsetHeight
    );
    var maxHeight = Math.floor(window.innerHeight * 0.85);
    var finalHeight = Math.min(Math.max(contentHeight + 8, 180), maxHeight);
    frame.style.height = finalHeight + 'px';
  } catch (e) {
    frame.style.height = '75vh';
  }
}

function openTacticalModal(event, url, title) {
  if (event) {
    event.preventDefault();
    event.stopPropagation();
  }

  var backdrop = document.getElementById('tactical-modal-backdrop');
  var frame = document.getElementById('tactical-modal-frame');
  var titleEl = document.getElementById('tactical-modal-title');
  if (!backdrop || !frame) return false;

  titleEl.textContent = title || 'CARREGANDO TERMINAL...';
  frame.style.height = '240px';
  frame.src = url;
  backdrop.classList.add('is-open');

  frame.onload = function() {
    try {
      var doc = frame.contentDocument || frame.contentWindow.document;
      if (doc) {
        if (doc.title) {
          titleEl.textContent = doc.title;
        }

        // Remove min-height: 100vh interno para medir apenas a altura real do conteúdo
        var styleTag = doc.getElementById('modal-iframe-autoheight-style');
        if (!styleTag && doc.head) {
          styleTag = doc.createElement('style');
          styleTag.id = 'modal-iframe-autoheight-style';
          styleTag.textContent = 'html, body { min-height: 0 !important; height: auto !important; margin: 0; overflow-x: hidden; }';
          doc.head.appendChild(styleTag);
        }

        resizeTacticalModalFrame();
        setTimeout(resizeTacticalModalFrame, 120);

        if (tacticalModalResizeObserver) {
          tacticalModalResizeObserver.disconnect();
        }
        if (window.ResizeObserver && doc.body) {
          tacticalModalResizeObserver = new ResizeObserver(function() {
            resizeTacticalModalFrame();
          });
          tacticalModalResizeObserver.observe(doc.body);
        }
      }
    } catch (e) {
      frame.style.height = '75vh';
    }
  };

  return false;
}

function closeTacticalModalAndReload(event) {
  if (event && event.target && event.target.id !== 'tactical-modal-backdrop') return;

  var backdrop = document.getElementById('tactical-modal-backdrop');
  var frame = document.getElementById('tactical-modal-frame');

  if (tacticalModalResizeObserver) {
    tacticalModalResizeObserver.disconnect();
    tacticalModalResizeObserver = null;
  }

  if (backdrop) backdrop.classList.remove('is-open');
  if (frame) frame.src = 'about:blank';

  window.location.reload();
}

document.addEventListener('keydown', function(e) {
  var backdrop = document.getElementById('tactical-modal-backdrop');
  if (e.key === 'Escape' && backdrop && backdrop.classList.contains('is-open')) {
    closeTacticalModalAndReload();
  }
});

window.addEventListener('resize', function() {
  var backdrop = document.getElementById('tactical-modal-backdrop');
  if (backdrop && backdrop.classList.contains('is-open')) {
    resizeTacticalModalFrame();
  }
});

// Evita erro nas views internas que chamam refreshParent() ao carregar
function refreshParent() {
  if (window.parent && window.parent !== window && typeof window.parent.resizeTacticalModalFrame === 'function') {
    window.parent.resizeTacticalModalFrame();
  }
}