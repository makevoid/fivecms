var $, State, bind_contents_close, close_contents, current_page_name, get_current_page, load_object, load_site, localStorage, location, main, storage, window;

if (!$) {
  $ = {};
  $.getJSON = function() {};
  localStorage = {};
  window = this;
  location = {};
  location.pathname = "/";
}

main = function(site_data) {
  var App, array, content, conts_controller, current_contents, current_page, pages, site, site_controller, _i, _len, _ref;

  App = Em.Application.create({
    LOG_TRANSITIONS: true
  });
  window.App = App;
  App.Site = Em.Object.extend();
  App.SiteController = Em.ObjectController.extend();
  App.ContsController = Em.ArrayController.extend();
  App.Content = Em.Object.extend({
    cont_string: Em.computed(function() {
      return new Handlebars.SafeString(textile(this.get("cont")));
    }).property("cont"),
    edit: function() {
      if (State.open) {
        close_contents();
        State.open = false;
      }
      return this.set("isEditable", true);
    },
    saved_cont: function() {
      this.set("isEditable", false);
      throw "wtf";
    }
  });
  array = load_site(site_data);
  site = App.Site.create();
  site.setProperties(array[0]);
  pages = array[1];
  conts_controller = App.ContsController.create({
    content: pages
  });
  site_controller = App.SiteController.create({
    content: site
  });
  current_page = get_current_page(pages);
  current_contents = [];
  _ref = current_page.contents;
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    content = _ref[_i];
    current_contents.pushObject(App.Content.create(content));
  }
  App.Router.reopen({
    location: 'history'
  });
  App.Router.map(function() {
    return this.route("page", {
      path: "/pages/:page_id"
    });
  });
  App.IndexRoute = Em.Route.extend({
    model: function() {
      return site_controller.get('content');
    }
  });
  App.PageRoute = Em.Route.extend({
    model: function() {
      return site_controller.get('content');
    }
  });
  App.PageController = Em.ObjectController.extend({
    page: current_page,
    conts: current_contents,
    needs: "site",
    init: function() {
      return site.set("name", storage.site_name);
    },
    add: function() {
      var cont;

      cont = App.Content.create({
        cont: "edit me..."
      });
      this.get('conts').pushObject(cont);
      cont.edit();
      return false;
    },
    site_name_edit: function() {
      return site.set('isEditingSiteName', true);
    },
    site_name_save: function() {
      site.set('isEditingSiteName', false);
      return storage.site_name = site.get('name');
    },
    site_nav_edit: function() {
      return site.set('isEditingNav', true);
    },
    site_nav_save: function() {
      return site.set('isEditingNav', false);
    },
    site_nav_add: function() {
      var page;

      pages = site.get("pages");
      page = Em.Object.create({
        name: "new page...",
        url: "/temp_url"
      });
      return pages.pushObject(page);
    }
  });
  App.IndexController = App.PageController;
  App.IndexView = Em.View.extend({
    layoutName: 'page-layout',
    classNames: ["inner_container"]
  });
  App.PageView = Em.View.extend({
    layoutName: 'page-layout',
    templateName: 'index',
    classNames: ["inner_container"]
  });
  App.ApplicationView = Em.View.extend({
    classNames: ["container"]
  });
  return bind_contents_close();
};

$.getJSON("/sites/1.json", function(site_data) {
  return main(site_data);
});

State = {};

State.open = false;

storage = localStorage;

window.storage = storage;

if (!storage.sites) {
  storage.sites = [];
}

get_current_page = function(pages) {
  var pag;

  pag = _(pages).find(function(page) {
    return page.name_url === current_page_name;
  });
  return pag || _(pages).first();
};

close_contents = function() {
  var cont, controller, controllers, conts, _i, _len, _results;

  controllers = App.Router.router.currentHandlerInfos;
  controller = _(controllers).find(function(contr) {
    return contr.name === "index" || contr.name === "page";
  });
  conts = controller.handler.controller.get('conts');
  _results = [];
  for (_i = 0, _len = conts.length; _i < _len; _i++) {
    cont = conts[_i];
    _results.push(cont.set("isEditable", false));
  }
  return _results;
};

bind_contents_close = function() {
  var win;

  win = $(window);
  return win.on("click", function(evt) {
    var has_cont, target;

    target = $(evt.target);
    has_cont = target.parents(".cont").length;
    window.target = target;
    if (!has_cont) {
      if (State.open) {
        close_contents();
      }
      return State.open = true;
    }
  });
};

current_page_name = location.pathname.split("/")[2];

load_object = function(object) {
  var key, page, _i, _len, _ref;

  page = Em.Object.create();
  _ref = _(object).keys();
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    key = _ref[_i];
    page.set(key, object[key]);
  }
  return page;
};

load_site = function(site_data) {
  var page, pages, site, _i, _len, _ref;

  pages = [];
  _ref = site_data.pages;
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    page = _ref[_i];
    page = load_object(page);
    pages.pushObject(page);
  }
  site = Em.Object.create({
    name: site_data.name,
    domain: site_data.domain,
    nav: site_data.nav,
    pages: pages
  });
  return [site, pages];
};

Em.Handlebars.helper('textile', function(value) {
  return new Handlebars.SafeString(textile(value));
});
