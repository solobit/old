// Generated by CoffeeScript 1.6.2
var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

module.exports = function(BasePlugin) {
  var DownloaderPlugin, ProgressBar, TaskGroup, domain, fsUtil, hyperquest, pathUtil, rimraf, stream, tar, zlib, _ref;

  TaskGroup = require('taskgroup').TaskGroup;
  hyperquest = require('hyperquest');
  tar = require('tar');
  rimraf = require('rimraf');
  ProgressBar = require('progress');
  zlib = require('zlib');
  fsUtil = require('fs');
  pathUtil = require('path');
  stream = require('stream');
  domain = require('domain');
  return DownloaderPlugin = (function(_super) {
    __extends(DownloaderPlugin, _super);

    function DownloaderPlugin() {
      _ref = DownloaderPlugin.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    DownloaderPlugin.prototype.name = 'downloader';

    DownloaderPlugin.prototype.config = {
      downloads: null,
      cleanOnReset: false
    };

    DownloaderPlugin.prototype.generateBefore = function(opts, next) {
      var cleanOnReset, config, docpad, docpadConfig, downloads, tasks;

      docpad = this.docpad;
      config = this.getConfig();
      downloads = config.downloads || [];
      cleanOnReset = config.cleanOnReset;
      if (downloads.length === 0 || (cleanOnReset && opts.reset === false)) {
        return next();
      }
      docpadConfig = docpad.getConfig();
      downloads.forEach(function(download) {
        return download.path = download.path.replace(/^src\/documents/, docpadConfig.documentsPaths[0]).replace(/^src\/files/, docpadConfig.filesPaths[0]).replace(/^src/, docpadConfig.srcPath).replace(/^out/, docpadConfig.outPath);
      });
      tasks = new TaskGroup().setConfig({
        concurrency: 0
      }).once('complete', function(err) {
        var cleanTasks;

        if (!err) {
          return next();
        }
        docpad.warn(err);
        cleanTasks = new TaskGroup().setConfig({
          concurrency: 0
        }).once('complete', next);
        downloads.forEach(function(download) {
          return cleanTasks.addTask(function(complete) {
            return rimraf(download.path, complete);
          });
        });
        return cleanTasks.run();
      });
      downloads.forEach(function(download) {
        return tasks.addTask(function(complete) {
          var d;

          if (fsUtil.existsSync(download.path) === true) {
            return complete();
          }
          d = domain.create();
          d.on('error', complete);
          return d.run(function() {
            var out, req;

            req = hyperquest(download.url, {
              headers: {
                'accept-encoding': 'gzip,deflate'
              }
            });
            out = req;
            return req.on('response', function(res) {
              var bar, cleanDirs, len, _ref1, _ref2, _ref3, _ref4;

              len = res.headers['content-length'] || 0;
              if (len) {
                len = parseInt(len, 10);
                bar = new ProgressBar("Downloading " + download.name + " [:bar] :percent :etas", {
                  complete: '=',
                  incomplete: ' ',
                  width: 20,
                  total: len
                });
                res.on('data', function(chunk) {
                  return bar.tick(chunk.length);
                });
                res.on('end', function() {
                  return console.log('\n');
                });
              } else {
                docpad.log('info', "Downloading " + download.name);
              }
              if ((_ref1 = download.deflate) == null) {
                download.deflate = res.headers['content-encoding'] === 'deflate';
              }
              if ((_ref2 = download.gzip) == null) {
                download.gzip = res.headers['content-encoding'] === 'gzip' || (res.headers['content-type'] || '').indexOf('gzip') !== -1;
              }
              if ((_ref3 = download.tarExtract) == null) {
                download.tarExtract = (res.headers['content-disposition'] || '').indexOf('.tar') !== -1;
              }
              if ((_ref4 = download.tarExtractClean) == null) {
                download.tarExtractClean = false;
              }
              if (download.deflate) {
                out = out.pipe(zlib.createInflate());
              }
              if (download.gzip) {
                out = out.pipe(zlib.createGunzip());
              }
              if (download.tarExtract) {
                out = tar = out.pipe(tar.Extract(download.path));
                if (download.tarExtractClean) {
                  cleanDirs = [];
                  tar.on('entry', function(entry) {
                    var entryPathParts, _ref5;

                    entryPathParts = entry.path.split(/[\\\/]/);
                    if (_ref5 = entryPathParts[0], __indexOf.call(cleanDirs, _ref5) < 0) {
                      cleanDirs.push(entryPathParts[0]);
                    }
                    return entry.path = entryPathParts.slice(1).join(pathUtil.sep);
                  });
                  tar.on('close', function() {
                    return cleanDirs.forEach(function(cleanDir) {
                      return tasks.addTask(function(complete) {
                        return rimraf(pathUtil.join(download.path, cleanDir), complete);
                      });
                    });
                  });
                }
              } else {
                out = out.pipe(fsUtil.createWriteStream(download.path));
              }
              return out.on('close', complete);
            });
          });
        });
      });
      tasks.run();
    };

    return DownloaderPlugin;

  })(BasePlugin);
};