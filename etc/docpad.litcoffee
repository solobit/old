
    fs      = require 'fs'
    path    = require 'path'

# DocPad instellingen

Dit bestand is het belangrijkste, althans meest prominent zichtbare,
bestand in een reeks welke op een of andere wijze uw site instellen.

## Helpers

Dit zijn functies die ons vanuit de buitenste scope kunnen assisteren met het
eenvoudiger werken in dit bestand. Zoals met alleen `afbeelding('plaatje.img')`
het gehele pad ophalen:

    afbeelding      = (img) -> return '/media/afbeeldingen/' + img

Of teksten met veel witte regels netjes samenvoegen:

    samenvoegen     = (txt) -> return txt.trim().split('\n')

Een handig kort logje

    log = console.log

# Node modules



Node.js modules are basically just files with code, essentially
JavaScript but optionally compiled from another language such as
CoffeeScript, ClojureScript etc. The files, or modules, can share their
methods and properties with eachother, as long as these files exposed
their data to the outside world.

Het volgende letterlijke object 'literal hash' ook wel genoemd, of een
key:value paar, een set met sleutels elk met een waarde.

```js
hash = { 'key' : 'value' }
hash = { 'key1': 'value', 'key2': 123 }
hash = { 'key': [1, 2, 3]}
```

Dit mogen ook functies `->` zijn, alleen geen statements `=` tenzij binnen in
een functie.

    siteInstellingen = {


## Gebeurtenissen (events)
 
Event handlers in DocPad receive two arguments. The first is `opts`
which is an object filled with properties that the event may provide to
you. The second is `next` which is a completion callback. Both arguments
are **optional**.

Events are fired in a synchronous serial fashion, meaning fire the first
handler, wait for it to finish, fire the next handler, wait for it to
finish, and so on.

Omitting the next callback is perfectly valid and encouraged when you
are writing synchronous code. Synchronous code is code that runs
everything from start to finish in one go. Asynchronous code however is
code that will run a portion at one time, and another portion at another
time. With asynchronous code a completion callback is necessary for us
to know when everything has properly run, or rather when it is okay to
proceed to the next task (or in this case event handler).
 
        events:

Used to add our own custom routes to the server before the docpad routes
are added
 
Bekijken we puur (via `nesh -c`) wat we krijgen als we docpad
initialiseren, dan zien we dat het `_events` (het liggend streepje
simu-/impliceert een private scope) object ons de volgende sleutels geeft.

Een aantal zijn volgens mij echter geen bruikbare `events` in de zin dat
deze niet in de documentatie vermeldt staan. Voor de volledigheid heb ik
deze echter hier nog staan.

* extendTemplateData: ->
* extendCollections: ->
* contextualizeBefore: ->
* contextualizeAfter: ->
* populateCollections: ->
* docpadLoaded: ->
* log: ->

Vervolgens geeft de docpad site ons nog een aantal hints over wat voor
argumenten deze functies mogen verwachten. Ook deze zijn er in verwerkt,
samen met een pakkende, zo volledig mogelijke Nederlandstalige
omschrijving.

### DocPad gereed met laden

Een gebeurtenis gezonden zodra een DocPad exemplaar gemaakt is en de
instellingen daarin geladen zijn. Er is nog geen server gemaakt of
bestanden getransformeerd: de site is nog niet gegenereerd!

#### Functiesleutel

            docpadReady: -> #console.log @docpad

#### Argumentenlijst

* `{docpad}` Een exemplaar van het docpad object

#### Omschrijving

Deze gebeurtenis wordt uitgezonden (door middel van een Node.js
`EventEmitter.emit()` methode) wanneer DocPad gereed is om 'acties' uit
te voeren (dp official docs). Meer specifiek gaat het hier om het maken
van een nieuw exemplaar (een zgn `instance`) van de DocPad structuur
door middel van het aanroepen van de methode `.createInstance()` van de
DocPad module. Vervolgens worden de, onder andere, in dit bestand
opgeslagen **instellingen geladen in het nieuwe exemplaar**. Dit gebeurt
dus iedere keer, wanneer bijvoorbeeld de commandos `docpad generate` of
`docpad run` vanaf de opdrachtregel gegeven worden.

### Opdrachtregel gereed met laden

De gebeurtenis `consoleSetup` wordt uitgezonden op het moment zodra de
interface voor de opdrachtregel (de `CLI` of Command Line Interface)
**daadwerkelijk succesvol geladen** is.

##### Functie en argumenten

De functie voor de gebeurtenis is opgeslagen als de waarde van een
sleutel. Feitelijk betreft het hier een letterlijk `Function` object
gecreeerd door het gebruik van het sleutelwoord `function` in JavaScript
(deze bestaat niet in CoffeeScript, `function() { ... }` is hierin
verkort als `() ->` of zelfs `->` weergegeven).

            consoleSetup: ->

Deze argumenten worden als functie parameters doorgegeven aan de
gebeurtenis, DocPad noemt deze gebundeld `options`.

1. consoleInterface • Een exemplaar van de CLI
1. commander • Een exemplaar van commander.js

Daarnaast wordt aan iedere functie een zgn. closure meegegeven genaamd
`next`, deze gebruikt men om de volgende achtereenvolgende stap te aan
te roepen.

### Voorafgaand aan genereren web site

            generateBefore: ->

### Genereren van site voltooid

            generateAfter: ->

### NOOT CHECK: Verschil tussen genereren en parsen (transformeren) ##

            parseBefore: ->

            parseAfter: ->

            renderBefore: ->

### Transformeren van bestandsextensies

Een van de belangrijkste functies van docpad is het renderen of
transformeren.

#### Functiesleutel

            render: ->

#### Argumentenlijst

* `inExtension` • de extensie waarvandaan we transformeren
* `outExtension` • de extensie waar we naartoe transformeren
* `templateData` • de docpad template gegevens zoals hieronder
* `file` • het model van 'bestand' dat we gebruiken
* `content` • de inhoud van een document (dus zonder meta-gegevens)

#### Omschrijving

Render wordt, in tegenstelling tot het merendeel van de andere
gebeurtenissen, **per document** en **per extensie** uitgezonden. Dit is
om transformaties mogelijk te maken, van het ene bestandstype naar het
andere zeg maar. DocPad is een taalonafhankelijk systeem wat
eenvoudigweg mogelijk maakt om van de ene opmaaktaal naar een andere te
veranderen: van CoffeeScript naar JavaScript, of van Jade naar HTML, het
maakt niet uit (zolang er maar een plugin voor is).

#### Voorbeeld

Een bestand `mijn_document_1` wat dus getransformeerd wordt door
`Coffeecup` om van een `.coffee` bestand een `.html` bestand te maken,
binnen docpad met dubbele extensie gemarkeerd **voor iedere
bestandsextensie** in de naam van dat document (dus voor bijvoorbeeld
`bestand123.html.md.coffee` twee keer) aangeroepen.

            renderDocument: ->

            renderAfter: ->

            writeBefore: ->

            writeAfter: ->

            serverBefore: ->

            serverExtend: ->

            serverAfter: ->

### Render After

Event fired after rendering has taken place. Hiermee halen we alle uiteindelijke
HTML bestanden op die we tegen een remote SEO tool kunnen gebruiken.

            renderAfter: ->

                ###
                docpad = @docpad
                docpad.log 'info', 'Listing all generated page urls'
                documents = docpad.getCollection('html')

                documents.forEach (document) ->

                documentName = document.get('name')
                documentPath = document.get('path')
                ###

                #console.log document.get('outFilename')


Volgende in de wachtrij

                #next()?

Welke server poort gebruiken we? De `1337`-port aka 'elite' is tijdens
development in gebruik.

        port: 1337


Localized path names

        srcPath:        'site'

        outPath:        'www-uitvoer'  #'data/uitvoer'

        cfgPath:        'etc'

Arrays to allow more than one path also localized

        pluginsPaths:   ['node_modules', 'modules/node_modules', 'modules/plugins']

        documentsPaths: ['documents', 'documenten']

        filesPaths:     ['files', 'public', 'bestanden']

        layoutsPaths:   ['layouts', 'sjablonen']


## Plugins

### Aan- / uitschakelen van plugins

Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Nam cursus. Morbi ut
mi. Nullam enim leo, egestas id, condimentum at, laoreet mattis, massa.

        enabledPlugins:

            absolutepath:           true

            pathtoroot:             false

            munge:                  false

            text:                   false

            literate:               false


### Plugins configureren

Veelal in de plugin map zelf. Maar ook vanuit hier aan te passen, toe te voegen,
modificeren...*((+))*

        plugins:

            partials:

                partialsPath:       'bouwstenen'

Since partials are not part of the core framework localize the path name here

            sitemap:

                cachetime:          600000

                changefreq:         'yearly'

                priority:           0.8

Something:

* `name` string, name of the download, for logging purposes only
* `path` string, path that the completed download is placed
* `url` string, url the download is retrieved from
* `deflate` boolean, whether or not we should deflate the response when
  fetching the download (auto-detected if not set)
* `gzip` boolean, whether or not we should unzip the response when
  fetching the download (auto-detected if not set)
* `tarExtract` boolean, whether or not we should extract tar downloads
  (auto-detected if not set)
* `tarExtractClean` boolean, whether or not when performing a tar
  extraction if we should remove the root directory of the extracted
  files

And then some

Gedeeld

        templateData:

## Organisatie

Uw organisatie, dat *bent* u. Met uw medewerkers, (zaken)partners,
materieel kortom: mensen en middelen. Daarmee heeft uw bedrijf, o.a. een
identiteit. *((+))* 

            org:

                bedrijfsnaam:     'Tredius'

                bedrijfslogo:     afbeelding('bedrijfslogo.png')

                omschrijving:     "

                    Tredius verleent financiële-, fiscale-, juridische-,
                    personele- en bedrijfsadministratieve diensten aan
                    het MKB van Nederland

                ".replace(/\s+/g, " ")

                auteursrecht:     "#{new Date().getFullYear() + ' © Tredius.nl'}"

                bezoekadres:

                    straat:       'Zijlweg 146'
                    postcode:     '2015 BH'
                    plaats:       'Haarlem'

                postadres:

                    postbus:      'Postbus 992'
                    postcode:     '2003 RZ'
                    plaats:       'Haarlem'

                contactgegevens:

                    telefoon:     '023 551 30 55'
                    fax:          '023 551 30 35'
                    email:        'info@tredius.nl'

                handelsgegevens:

                    kvk:          '3782878'
                    btw:          'NL8124.72.792.B01'
                    bedrijfsvorm: 'Besloten Venootschap (BV)'

                contactpersonen:

                    marco:
                        naam:       'Marco Krijger MB FB'
                        titel:      'Partner Tredius Fiscalisten'
                        email:      'm.krijger@tredius.nl'

                    linda:
                        naam:       'Linda Honig'
                        titel:      ''
                        telefoon:   '023 551 30 55'
                        email:      ''

                    lennard:
                        naam:       'Lennard Honig'
                        titel:      ''
                        telefoon:   '023 551 30 55'
                        email:      ''

                    luuk:
                        naam:       'Luuk Oosting'
                        titel:      ''
                        telefoon:   '0299 651 987'
                        email:      ''

                    wil:
                        naam:       'Wil Buffing'
                        titel:      ''
                        telefoon:   '0299 411 345'
                        email:      ''



### Vestigingen, regio-. hoofdkantoren en overige locaties

Afdelingen of vestigingen op die geografische locaties anders dan de
hoofdafdeling / organisatie. Deze kunnen zowel national als
internationaal gelegen zijn *((..))*

                vestigingen:

#### Purmerend

                    purmerend:

##### Bezoekadres

                        bezoekadres: samenvoegen """
                            Wielingenstraat 119
                            1441 ZN
                            Purmerend
                            Noord-Holland
                            Nederland
                            """

##### Postadres

                        postadres: samenvoegen """
                            Postbus 258
                            1440 AG
                            Purmerend
                            """

                        telefoon:   "0299 411 345"

                        fax:        "0299 411 348"

                        email:      "info@tredius.nl"

                        geocode:    ['52.503605', '4.958375']

                        rest: "geocode=Cc9PzZeFjzXfFYEnIQMdp59LACmPF3Re0AbGRzF_fLmc8BNprg&amp;sll=52.504454,4.956079&amp;sspn=0.009065,0.019054&amp;mra=pd&amp;t=m&amp;spn=0.0064,0.013282"

#### Monnickendam

                    monnickendam:

                        bezoekadres: samenvoegen """
                            Haringburgwal 17
                            1141 AT
                            Monnickendam
                            Noord-Holland
                            Nederland
                            """

                        postadres: samenvoegen """
                            Postbus 48
                            1140 AA
                            Monnickendam
                            """

                        telefoon:   '0299 651 987'

                        fax:        '0299 653 004'

                        email:      'info@tredius.nl'

                        geocode:    ['52.462874', '5.035343']

                        rest: "geocode=CXRphrBe0kPwFRuFIAMdStVMACln1vctrAXGRzHfFo4FDFJsxg&amp;aq=&amp;sll=52.505806,4.827991&amp;sspn=0.269159,0.835648&amp;mra=pd&amp;spn=0.006406,0.013282"

#### Alkmaar

                    alkmaar:

                        bezoekadres: samenvoegen """
                            Professor van der Waalsstraat 3K
                            1821 BT
                            Alkmaar
                            Noord-Holland
                            Nederland
                            """

                        postadres: samenvoegen """
                            Professor van der Waalsstraat 3K
                            1821 BT
                            Alkmaar
                            """

                        telefoon:   '072 564 4203'

                        fax:        '072 564 3019'

                        email:      'info@tredius.nl'

                        geocode:    ['52.625092', '4.770384']

                        rest:       "spn=0.006382,0.013282"

#### Haarlem

                    haarlem:

                        bezoekadres: samenvoegen """
                            Zijlweg 146
                            2015 BH
                            Haarlem
                            Noord-Holland
                            Nederland
                            """

                        postadres: """
                            Postbus 992
                            2003 RZ
                            Haarlem
                            """

                        telefoon:   '023 551 30 55'

                        fax:        '023 551 30 35'

                        email:      'info@tredius.nl'

                        geocode:    ['52.386457', '4.620631']

                        rest: "geocode=CWxUaXo29tzfFddYHwMdWoFGACkH_TJiEO_FRzHom-tyuYRbow&amp;sll=52.386457,4.620631&amp;sspn=0.008434,0.026114&amp;mra=iwd&amp;spn=0.006417,0.013282"



            site:

                naam:             'Tredius.nl'

                url:              'http://www.tredius.nl'

                static:           'http://static.tredius.nl'

                development:      'http://solobit.github.io/tredius'

                auteur:           'Solobit &amp; Edberry Creative'

                contact:          'info@tredius.nl'

                lang:             () -> process.env.LANG
                taal:             'xml:lang': 'nl'

                essentie: "
                Tredius verleent financiële-, fiscale-, juridische-,
                personele- en bedrijfsadministratieve diensten aan het MKB
                van Nederland".replace(/\s+/g, " ")

                omschrijving: "
                Bij Tredius hebben we de behoefte om het MKB landschap te
                veranderen: Vrijheid, Onafhankelijkheid en Zelfstandigheid,
                voor iedere ondernemer.".replace(/\s+/g, " ")

                keywords: "
                belasting, advies, accountancy, pensioenbelasting,
                bedrijfsadministratie, vrijheid, onafhankelijkheid,
                zelfstandigheid".replace(/\s+/g, " ")

                beheer:           'rob.jentzema@gmail.com'

                googleanalytics:  'UA-39413290-1'

                techniek: "
                Node.js, Docpad, jQuery, Semantic Grid, Stylus, Jade,
                CoffeeScript, Markdown, Accessible Rich Internet
                Applications (WAI-ARIA) ".replace(/\s+/g, " ")

                disclaimer: "
                De informatie zoals opgenomen in bovenstaand artikel is
                uitsluitend bestemd voor algemene informatiedoeleinden.
                Derhalve dienen op grond van deze informatie geen
                handelingen te worden verricht zonder voorafgaand deskundig
                advies. Voor een toelichting kunt u uiteraard contact
                opnemen met een van onze kantoren. ".replace(/\s+/g, " ")


## Client-side browser JavaScript

Dit kan een gecompliceerd onderwerp zijn. Het probleem zit hem onder
andere in het volgende:

* JavaScript kan geminimaliseerd worden (spaties en nieuwe regels
  verwijderen). Een vorm van compressie waardoor JS nog steeds werkt
  maar de bestandsgrootte kleiner is geworden. Dit is alleen niet handig
  tijdens ontwikkeling van scripts en moet dus tot het einde uitgesteld
  worden, ook tijdens het draaien in de browser van de ontwikkelaar.
  Maar er zijn tools die automatisch die bestanden in de gaten houden
  wanneer ze opgeslagen worden, daarna minimize deze. Maar hoe zie je ze
  in de browser? Compressed, dus tool nodig voor uncompress in Browser!

* Scripts kunnen `sync` of `defer` zijn (`defer` is uitgesteld synchroon)
* niet alle scripts zijn geschikt voor defer want JS in een modulaire
  pagina kan al geladen zijn terwijl de dependency niet in de head zat
  en dus te laat binnen is en niets meer werkt.

> ((!!)) Prio: omzetten naar AMD met Volo



                blockingScripts: """
                    //ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js
                    //ajax.googleapis.com/ajax/libs/jqueryui/1.10.1/jquery-ui.min.js
                    //code.createjs.com/preloadjs-0.3.0.min.js
                    /assets/modernizr-custom.js
                    """.trim().split('\n')
                #//yui.yahooapis.com/3.8.0/build/yui/yui-min.js
                #/assets/ender.min.js


                nonBlocking: """
                    /assets/ui.js
                    /assets/jquery.cookie.js
                    /assets/jquery.circlemenu.js
                    /assets/vimeo.froogaloop2.min.js
                    /assets/mediaverbindingen.js
                    /assets/dragdealer.js
                    /assets/jquery.colorbox.js
                    /assets/jquery.easing.min.js
                    """.trim().split('\n')
                    # /assets/jquery.hypher.js
                    # /assets/cross-domain.js


### Vormgeving

Hier komt een stukje over stijlen die gebruikt zijn.

                stijl:

                    lettertype: "
                    //fonts.googleapis.com/css?family=Dosis:400,500,600
                    |Open+Sans:400italic,600italic,700italic,400,600,700
                    ".replace(/\s+/g, " ")

                    icoon:      "/media/afbeeldingen/favicon.png"

TODO: automatisch toevoegen van random voor cache tijdens development fase en niet comprimeren.

                    volatile: [
                        '/stijlen/algemeen.css' + '?' + new Date().getTime() / 1000
                    ]

Deze wel compressen

                    bladen: [
                        '/stijlen/algemeen.css' + '?' + new Date().getTime() / 1000
                        '/stijlen/circlemenu.css'
                        '/stijlen/dragdealer.css'
                        '/stijlen/ui.css'
                    ]


### Snelkoppelingen

Veel gebruikte snelkoppelingen / hyperlinks

                snelkoppelingen:

                    debiteuren:
                        tekst:  'Tredius Debiteurenbeheer'
                        url:    '/diensten/debiteurenbeheer/index.html'
                        titel:  'Tredius Debiteurenbeheer is duurzaamheid voorop'

                    stappenplan:
                        tekst:  'Tredius Debiteurenbeheer Stappenplan'
                        url:    '/diensten/debiteurenbeheer/stappenplan.html'
                        titel:  'Neem nu een Tredius Debiteurenbeheer Abonnement'

                    debiteurenabo:
                        tekst: 'Tredius Debiteuren Abonnement'
                        url:    '/diensten/debiteurenbeheer/abonnement.html'
                        titel:  'Neem nu een Tredius Debiteurenbeheer Abonnement'

                    voorwaarden:
                        tekst:  'voorwaarden'
                        url:    '/overig/voorwaarden.html'
                        titel:  'Lees onze algemene voorwaarden'


### (Web 3.0) Vocabularies of web ontologies
XML Namespace URI's for the semantic web <http://www.w3.org/2001/sw/>

What is the Semantic Web? The Semantic Web provides a common framework
that allows data to be shared and reused across application, enterprise,
and community boundaries. It is a collaborative, very-long term effort
led by [W3C][w3c] with participation from a large number of researchers and
industrial partners.

It is based on the [Resource Description Framework (RDF)][rdf].

[rdf]: <www>
[w3c]: <www>

                vocabulaire: {'xmlns:s'     : 'http://schema.org/'

[Schema.org][s] provides a collection of shared vocabularies webmasters
can use to mark up their pages in ways that can be understood by the
major search engines: Google, Microsoft, Yandex and Yahoo! You use the
schema.org [vocabulary][sv], along with the microdata format, to add
information to your HTML content. While the long term goal is to support
a wider range of formats, the initial focus is on Microdata.


                            , 'xmlns:gr'    : 'http://purl.org/goodrelations/v1#'
                            , 'xmlns:rdfs'  : 'http://www.w3.org/2000/01/rdf-schema#'
                            , 'xmlns:vcard' : 'http://www.w3.org/2006/vcard/ns#'


The [Friend of a Friend (FOAF)][foaf] project is creating a Web of
machine- readable pages describing people, the links between them and
the things they create and do; it is a contribution to the linked
information system known as the Web. FOAF [defines][foafs] an open,
decentralized technology for connecting social Web sites, and the people
they describe. FOAF is a simple technology that makes it easier to share
and use information about people and their activities (eg. photos,
calendars, weblogs), to transfer information between Web sites, and to
automatically extend, merge and re-use it online.

                            , 'xmlns:foaf'  : 'http://xmlns.com/foaf/0.1/'


The Open Graph protocol enables any web page to become a rich object in
a social graph. For instance, this is used on Facebook to allow any web
page to have the same functionality as any other object on Facebook.

[Klik hier voor meer informatie](/handleiding/semantisch/ogp.html)


                            , 'xmlns:xsd'   : 'http://www.w3.org/2001/XMLSchema#'
                            , 'xmlns:v'     : 'http://rdf.data-vocabulary.org/#'
                            , 'xmlns:pto'   : 'http://www.productontology.org/id/'
                            , 'xmlns:wn'    : 'http://xmlns.com/wordnet/1.6/'}

[s]: <http://schema.org/docs/gs.html>
[sv]: <http://schema.org/docs/full.html>
[ogp]: <http://ogp.me/>
[foaf]: <http://www.xml.com/pub/a/2004/02/04/foaf.html>
[foafs]: <http://xmlns.com/foaf/spec/>

## Hulpfuncties (helpers)

Deze helpen ons met verschillende dingen.

            getVimeoUri: (id) ->
                return "http://player.vimeo.com/video/#{id}?api=1&amp;player_id=VideoSpeler-#{id}&amp;title=0&amp;byline=0&amp;portrait=0&amp;badge=0&amp;color=e31741"


Samenstellen van mail API address voor 'post'

            getMailUri: ({id,ds}) ->

                return "" if id? or ds?

                formulier =
                    #  frm    MailingListID - DatasetID
                    nieuwsbrief: [ 145464     , 20853 ]
                    neemcontact: [ 145467     , 20853 ]
                    jabonnement: [ 145467     , 20853 ]
                    dabonnement: [ 145467     , 20853 ]
                    vacaturescv: [ 145472     , 20853 ]

Samenstellen en encoden van mail API URI

                api     = encodeURI          "http://www.graphicmail.nl/api.aspx?"
                sid     = encodeURIComponent "SID=4"
                b64     = encodeURIComponent "&Credentials=DtZEdUEEcUap7RsVxnxyWux37VTOip2Xp2M+gIusSMwpc9Hu7nDCFm2LffostDgC/8lkV84pfIARSyMl/Hfamx4oG8mt/mk8o+UsteAhNqMs/qO3lhsagAKn4EtikhystNc17yejBNe2b+pfgz1pwRTA3F1AwxkI87/m5D+5kPkj2DLiRn/CFk4UBeiBT37fW+kniU94iIxHeoOThig3YRuLGaxd3LeSloSHW1xcaEhMpaP+uFozdVPBBf5cVZwjx63xVLa5+jQZBf7UM9zaew=="
                func    = encodeURIComponent "&Function=post_add_email_and_data"
                mlid    = encodeURIComponent "&MailingListID=#{id}"
                dsid    = encodeURIComponent "&DatasetID=#{ds}"

Closure

                api + sid + mlid + dsid + b64 + func

QueryEngine / Backbone modellen

            verzameling: (query) -> @getCollection('documents').findAllLive(query).toJSON()

Daadwerkelijke pad achterhalen

            urlOphalen: (document) ->
                return @site.url + (document.url or document.get?('url'))

            plaatsLink: (naam) ->
                link = @site.snelkoppelingen[naam]
                anker = """
                    <a href="#{link.url}" title="#{link.titel}" class="#{link.cssKlasse or ''}">#{link.tekst}</a>
                    """
                return anker

Als voorbeeld overgebleven

        collections:

            pages: -> @getCollection('documents').findAllLive({pageOrder:$exists:true},[pageOrder:1])

        }


### Publieke toegang

Exporteer het configuratie object naar overige modules welke deze willen
benaderen hiervoor.

    module.exports = siteInstellingen

    ###
    cs        = require 'coffee-script'
    infile    = path.resolve(__filename)
    litcoffee = fs.readFileSync(infile, 'utf-8')
    coffee    = cs.helpers.invertLiterate(litcoffee)
    
    try
        cs.compile coffee, bare:on, lint: on ,filename: 'docpad.js'
        log "Success!"
    catch e 
        log e if e

    ###
