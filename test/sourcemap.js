// Generated by CoffeeScript 1.6.2
(function() {
  var foo;

  require('source-map-support').install();

  foo = function() {
    var bar;

    bar = function() {
      throw new Error('this is a demo');
    };
    return bar();
  };

  foo();

}).call(this);

/*
//@ sourceMappingURL=demo.map
*/
