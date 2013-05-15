var afbeelding, compiled, compressor, cs, docpadConfig, educated, egaliseer, fs, geenspaties, i18n, litcoffee, log, path, path_languages, splits;

fs = require('fs');

path = require('path');

this.file_location = path.resolve(__filename);

this.path_minified = '../docpad.js';

this.path_compiled = 'docpad.compiled.js';

this.file_database = 'continents-cities-nl_NL.mo';

path_languages = "i18n/languages/";

afbeelding = function(img) {
  return '/media/afbeeldingen/' + img;
};

splits = function(txt) {
  return txt.trim().split('\n');
};

egaliseer = function(txt) {
  return txt.replace(/\s+/g, " ");
};

geenspaties = function(txt) {
  return txt.replace(/\s+/g, "");
};

log = console.log;

docpadConfig = {
  port: 1337,
  srcPath: 'site',
  outPath: 'www-uitvoer',
  cfgPath: 'etc',
  pluginsPaths: ['node_modules', 'modules/node_modules', 'modules/plugins'],
  documentsPaths: ['documents', 'documenten'],
  filesPaths: ['files', 'public', 'bestanden'],
  layoutsPaths: ['layouts', 'sjablonen'],
  enabledPlugins: {
    absolutepath: true,
    pathtoroot: false,
    munge: false,
    text: false,
    literate: false
  },
  plugins: {
    partials: {
      partialsPath: 'bouwstenen'
    },
    sitemap: {
      cachetime: 600000,
      changefreq: 'yearly',
      priority: 0.8
    }
  },
  templateData: {
    org: {
      bedrijfsnaam: 'Tredius',
      bedrijfslogo: afbeelding('bedrijfslogo.png'),
      omschrijving: egaliseer("\nTredius verleent financiële-, fiscale-, juridische-,\npersonele- en bedrijfsadministratieve diensten aan\nhet MKB van Nederland\n"),
      auteursrecht: "" + (new Date().getFullYear() + ' © Tredius.nl'),
      bezoekadres: {
        straat: 'Zijlweg 146',
        postcode: '2015 BH',
        plaats: 'Haarlem'
      },
      postadres: {
        postbus: 'Postbus 992',
        postcode: '2003 RZ',
        plaats: 'Haarlem'
      },
      contactgegevens: {
        telefoon: '023 551 30 55',
        fax: '023 551 30 35',
        email: 'info@tredius.nl'
      },
      handelsgegevens: {
        kvk: '3782878',
        btw: 'NL8124.72.792.B01',
        bedrijfsvorm: 'Besloten Venootschap (BV)'
      },
      contactpersonen: {
        marco: {
          naam: 'Marco Krijger MB FB',
          aanhef: '',
          titel: 'Partner Tredius Fiscalisten',
          email: 'm.krijger@tredius.nl'
        },
        linda: {
          naam: 'Linda Honig',
          aanhef: 'Mevr.',
          telefoon: '023 551 30 55',
          email: ''
        },
        lennard: {
          naam: 'Lennard Honig',
          aanhef: 'Dhr.',
          titel: '',
          telefoon: '023 551 30 55',
          email: ''
        },
        luuk: {
          naam: 'Luuk Oosting',
          aanhef: 'Dhr.',
          titel: '',
          telefoon: '0299 651 987',
          email: ''
        },
        wil: {
          naam: 'Wil Buffing',
          titel: 'Mevr.',
          telefoon: '0299 411 345',
          email: ''
        }
      },
      vestigingen: {
        purmerend: {
          bezoekadres: splits("                            Wielingenstraat 119                            1441 ZN                            Purmerend                            Noord-Holland                            Nederland                            "),
          geocode: ['52.503605', '4.958375'],
          rest: "geocode=Cc9PzZeFjzXfFYEnIQMdp59LACmPF3Re0AbGRzF_fLmc8BNprg&amp;sll=52.504454,4.956079&amp;sspn=0.009065,0.019054&amp;mra=pd&amp;t=m&amp;spn=0.0064,0.013282",
          postadres: splits("                            Postbus 258                            1440 AG                            Purmerend                            "),
          telefoon: "0299 411 345",
          fax: "0299 411 348",
          email: "info@tredius.nl"
        },
        monnickendam: {
          bezoekadres: splits("                            Haringburgwal 17                            1141 AT                            Monnickendam                            Noord-Holland                            Nederland                            "),
          geocode: ['52.462874', '5.035343'],
          rest: "geocode=CXRphrBe0kPwFRuFIAMdStVMACln1vctrAXGRzHfFo4FDFJsxg&amp;aq=&amp;sll=52.505806,4.827991&amp;sspn=0.269159,0.835648&amp;mra=pd&amp;spn=0.006406,0.013282",
          postadres: splits("                            Postbus 48                            1140 AA                            Monnickendam                            "),
          telefoon: '0299 651 987',
          fax: '0299 653 004',
          email: 'info@tredius.nl'
        },
        alkmaar: {
          bezoekadres: splits("                            Professor van der Waalsstraat 3K                            1821 BT                            Alkmaar                            Noord-Holland                            Nederland                            "),
          geocode: ['52.625092', '4.770384'],
          rest: "spn=0.006382,0.013282",
          postadres: splits("                            Professor van der Waalsstraat 3K                            1821 BT                            Alkmaar                            "),
          telefoon: '072 564 4203',
          fax: '072 564 3019',
          email: 'info@tredius.nl'
        },
        haarlem: {
          bezoekadres: splits("                            Zijlweg 146                            2015 BH                            Haarlem                            Noord-Holland                            Nederland                            "),
          geocode: ['52.386457', '4.620631'],
          rest: "geocode=CWxUaXo29tzfFddYHwMdWoFGACkH_TJiEO_FRzHom-tyuYRbow&amp;sll=52.386457,4.620631&amp;sspn=0.008434,0.026114&amp;mra=iwd&amp;spn=0.006417,0.013282",
          postadres: splits("                            Postbus 992                            2003 RZ                            Haarlem                            "),
          telefoon: '023 551 30 55',
          fax: '023 551 30 35',
          email: 'info@tredius.nl'
        }
      }
    },
    site: {
      naam: 'Tredius.nl',
      url: 'http://www.tredius.nl',
      "static": 'http://static.tredius.nl',
      development: 'http://solobit.github.io/tredius',
      auteur: 'Solobit &amp; Edberry Creative',
      contact: 'info@tredius.nl',
      lang: function() {
        return process.env.LANG;
      },
      taal: {
        'xml:lang': 'nl'
      },
      essentie: egaliseer("                Tredius verleent financiële-, fiscale-, juridische-,                personele- en bedrijfsadministratieve diensten aan het MKB                van Nederland                "),
      omschrijving: egaliseer("                Bij Tredius hebben we de behoefte om het MKB landschap te                veranderen: Vrijheid, Onafhankelijkheid en Zelfstandigheid,                voor iedere ondernemer.                "),
      keywords: egaliseer("                belasting, advies, accountancy, pensioenbelasting,                bedrijfsadministratie, vrijheid, onafhankelijkheid,                zelfstandigheid                "),
      googleanalytics: 'UA-39413290-1',
      techniek: egaliseer("                Node.js, Docpad, jQuery, Semantic Grid, Stylus, Jade,                CoffeeScript, Markdown, Accessible Rich Internet                Applications (WAI-ARIA)                 "),
      disclaimer: egaliseer("                De informatie zoals opgenomen in bovenstaand artikel is                uitsluitend bestemd voor algemene informatiedoeleinden.                Derhalve dienen op grond van deze informatie geen                handelingen te worden verricht zonder voorafgaand deskundig                advies. Voor een toelichting kunt u uiteraard contact                opnemen met een van onze kantoren.                "),
      support: {
        beheerder: 'Solobit',
        emailadres: 'rob.jentzema@gmail.com',
        servicelijn: '013-5906677'
      },
      blockingScripts: splits("                    //ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js                    //ajax.googleapis.com/ajax/libs/jqueryui/1.10.1/jquery-ui.min.js                    //code.createjs.com/preloadjs-0.3.0.min.js                    /assets/modernizr-custom.js                    "),
      nonBlocking: splits("                    /assets/ui.js                    /assets/jquery.cookie.js                    /assets/jquery.circlemenu.js                    /assets/vimeo.froogaloop2.min.js                    /assets/mediaverbindingen.js                    /assets/dragdealer.js                    /assets/jquery.colorbox.js                    /assets/jquery.easing.min.js                    "),
      stijl: {
        icoon: afbeelding('favicon.png'),
        lettertype: geenspaties("                    //fonts.googleapis.com/css?family=Dosis:400,500,600                    |Open+Sans:400italic,600italic,700italic,400,600,700                    "),
        volatile: ['/stijlen/algemeen.css' + '?' + new Date().getTime() / 1000],
        bladen: ['/stijlen/algemeen.css' + '?' + new Date().getTime() / 1000, '/stijlen/circlemenu.css', '/stijlen/dragdealer.css', '/stijlen/ui.css']
      },
      snelkoppelingen: {
        debiteuren: {
          tekst: 'Tredius Debiteurenbeheer',
          url: '/diensten/debiteurenbeheer/index.html',
          titel: 'Tredius Debiteurenbeheer is duurzaamheid voorop'
        },
        stappenplan: {
          tekst: 'Tredius Debiteurenbeheer Stappenplan',
          url: '/diensten/debiteurenbeheer/stappenplan.html',
          titel: 'Neem nu een Tredius Debiteurenbeheer Abonnement'
        },
        debiteurenabo: {
          tekst: 'Tredius Debiteuren Abonnement',
          url: '/diensten/debiteurenbeheer/abonnement.html',
          titel: 'Neem nu een Tredius Debiteurenbeheer Abonnement'
        },
        voorwaarden: {
          tekst: 'voorwaarden',
          url: '/overig/voorwaarden.html',
          titel: 'Lees onze algemene voorwaarden'
        }
      },
      vocabulaire: {
        'xmlns:s': 'http://schema.org/',
        'xmlns:foaf': 'http://xmlns.com/foaf/0.1/',
        'xmlns:xsd': 'http://www.w3.org/2001/XMLSchema#',
        'xmlns:v': 'http://rdf.data-vocabulary.org/#',
        'xmlns:pto': 'http://www.productontology.org/id/',
        'xmlns:wn': 'http://xmlns.com/wordnet/1.6/'
      }
    },
    getVimeoUri: function(id) {
      return "http://player.vimeo.com/video/" + id + "?api=1&amp;player_id=VideoSpeler-" + id + "&amp;title=0&amp;byline=0&amp;portrait=0&amp;badge=0&amp;color=e31741";
    },
    getMailUri: function(_arg) {
      var api, b64, ds, dsid, formulier, func, id, mlid, sid;

      id = _arg.id, ds = _arg.ds;
      if ((id != null) || (ds != null)) {
        return "";
      }
      formulier = {
        nieuwsbrief: [145464, 20853],
        neemcontact: [145467, 20853],
        jabonnement: [145467, 20853],
        dabonnement: [145467, 20853],
        vacaturescv: [145472, 20853]
      };
      api = encodeURI("http://www.graphicmail.nl/api.aspx?");
      sid = encodeURIComponent("SID=4");
      b64 = encodeURIComponent("&Credentials=DtZEdUEEcUap7RsVxnxyWux37VTOip2Xp2M+gIusSMwpc9Hu7nDCFm2LffostDgC/8lkV84pfIARSyMl/Hfamx4oG8mt/mk8o+UsteAhNqMs/qO3lhsagAKn4EtikhystNc17yejBNe2b+pfgz1pwRTA3F1AwxkI87/m5D+5kPkj2DLiRn/CFk4UBeiBT37fW+kniU94iIxHeoOThig3YRuLGaxd3LeSloSHW1xcaEhMpaP+uFozdVPBBf5cVZwjx63xVLa5+jQZBf7UM9zaew==");
      func = encodeURIComponent("&Function=post_add_email_and_data");
      mlid = encodeURIComponent("&MailingListID=" + id);
      dsid = encodeURIComponent("&DatasetID=" + ds);
      return api + sid + mlid + dsid + b64 + func;
    },
    uri: function(document) {
      return this.site.url + (document.url || (typeof document.get === "function" ? document.get('url') : void 0));
    },
    plaatsLink: function(naam) {
      var anker, link;

      link = this.site.snelkoppelingen[naam];
      anker = "<a href=\"" + link.url + "\" title=\"" + link.titel + "\" class=\"" + (link.cssKlasse || '') + "\">" + link.tekst + "</a>";
      return anker;
    }
  },
  collections: {
    verzameling: function(query) {
      return this.getCollection('documents').findAllLive(query).toJSON();
    }
  }
};

module.exports = docpadConfig;

i18n = require('i18next');

cs = require('coffee-script');

compressor = require('node-minify');

({
  i18Config: {
    preload: ['nl-NL'],
    lng: 'nl-NL',
    fallbackLng: false,
    load: 'current',
    detectLngQS: 'taal',
    useCookie: true,
    debug: true,
    keyseparator: '::',
    nsseparator: ':::',
    resGetPath: '../locales/__lng__/__ns__.json',
    ns: {
      namespaces: ['app'],
      defaultNs: 'app'
    }
  }
});

litcoffee = fs.readFileSync(this.file_location, 'utf-8');

educated = cs.helpers.invertLiterate;

compiled = cs.compile(educated(litcoffee), {
  bare: true
});

fs.writeFile(this.path_compiled, compiled, 'utf-8', function(err) {
  if (err) {
    return log(err);
  }
});

new compressor.minify({
  type: 'uglifyjs',
  fileIn: this.path_compiled,
  fileOut: this.path_minified,
  callback: function(err) {
    if (err) {
      throw err;
    }
  }
});
