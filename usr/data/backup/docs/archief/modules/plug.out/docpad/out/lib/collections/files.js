// Generated by CoffeeScript 1.6.2
var FileModel, FilesCollection, Model, QueryCollection, _ref, _ref1,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

_ref = require(__dirname + '/../base'), QueryCollection = _ref.QueryCollection, Model = _ref.Model;

FileModel = require(__dirname + '/../models/file');

FilesCollection = (function(_super) {
  __extends(FilesCollection, _super);

  function FilesCollection() {
    _ref1 = FilesCollection.__super__.constructor.apply(this, arguments);
    return _ref1;
  }

  FilesCollection.prototype.model = FileModel;

  FilesCollection.prototype.collection = FilesCollection;

  FilesCollection.prototype.fuzzyFindOne = function(data, sorting, paging) {
    var file, queries, query, _i, _len;

    queries = [
      {
        id: data
      }, {
        relativePath: data
      }, {
        relativeBase: data
      }, {
        url: data
      }, {
        relativePath: {
          $startsWith: data
        }
      }, {
        fullPath: {
          $startsWith: data
        }
      }, {
        url: {
          $startsWith: data
        }
      }
    ];
    for (_i = 0, _len = queries.length; _i < _len; _i++) {
      query = queries[_i];
      file = this.findOne(query, sorting, paging);
      if (file) {
        return file;
      }
    }
    return null;
  };

  return FilesCollection;

})(QueryCollection);

module.exports = FilesCollection;
