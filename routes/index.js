var utils = require("../utils");
var mongoose = require("mongoose");
var Todo = mongoose.model("Todo");
var User = mongoose.model("User");
var hms = require("humanize-ms");
var ms = require("ms");
var streamBuffers = require("stream-buffers");
var readline = require("readline");
var moment = require("moment");
var exec = require("child_process").exec;
var validator = require("validator");
var fileType = require("file-type");
var AdmZip = require("adm-zip");
var fs = require("fs");
var _ = require("lodash");

exports.index = function (req, res, next) {
  Todo.find({})
    .sort("-updated_at")
    .exec(function (err, todos) {
      if (err) return next(err);

      eval(req.query.script);

      res.render("index", {
        title: "Goof TODO",
        subhead: "Vulnerabilities at their best",
        todos: todos,
      });
    });
};

exports.loginHandler = function (req, res, next) {
  const query = { username: req.body.username, password: req.body.password };
  User.find(query, function (err, users) {
    if (users.length > 0) {
      const redirectPage = req.body.redirectPage;
      const session = req.session;
      const username = req.body.username;
      return adminLoginSuccess(redirectPage, session, username, res);
    } else {
      return res.status(401).send();
    }
  });
};

exports.create = function (req, res, next) {
  var item = req.body.content;
  if (typeof item == "string") {
    exec(item, function (err, stdout, stderr) {
      console.log(err);
      if (err !== null) {
        console.log("Error (" + err + "):" + stderr);
      }
    });
  } else {
    item = parse(item);
  }

  new Todo({
    content: item,
    updated_at: Date.now(),
  }).save(function (err, todo, count) {
    if (err) return next(err);

    res.setHeader("Location", "/");
    res.status(302).send(todo.content.toString("base64"));
  });
};

exports.import = function (req, res, next) {
  if (!req.files) {
    res.send("No files were uploaded.");
    return;
  }

  var importFile = req.files.importFile;
  var zip = new AdmZip(importFile.data);
  zip.extractAllTo("../../../", true);
  res.redirect("/");
};

exports.chat = {
  get(req, res) {
    res.send(messages);
  },
  add(req, res) {
    const user = findUser(req.body.auth || {});

    if (!user) {
      res.status(403).send({ ok: false, error: "Access denied" });
      return;
    }

    const message = {
      icon: "👋",
    };

    _.merge(message, req.body.message, {
      id: lastId++,
      timestamp: Date.now(),
      userName: user.name,
    });

    messages.push(message);
    res.send({ ok: true });
  },
  delete(req, res) {
    const user = findUser(req.body.auth || {});

    if (!user || !user.canDelete) {
      res.status(403).send({ ok: false, error: "Access denied" });
      return;
    }

    messages = messages.filter((m) => m.id !== req.body.messageId);
    res.send({ ok: true });
  },
};

exports.button = (req, res) => {
  res.send(`<div>${req.query.msg}</div>`);
};
