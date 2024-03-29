### cson
voetmenu:		3
layout:         'standaard'
kenmerk:        'ttime'
titel:          'Tredius vertelt...'
subtitel:       "T-Time"
naam: 		    "T-Time"
bannier:        'bg_ttime.jpg'
entity:         's:VideoObject'
type:           'video.movie'

samenvatting:   """ Op deze pagina vertellen wij welke ontwikkelingen er zijn op
de diverse gebieden. Dit doen wij in de vorm van filmpjes over actuele
onderwerpen, een nieuwsbrief en columns. Daarnaast brengen wij ook enkele malen
per jaar een T-time Special uit, waarin we dieper in gaan op een actueel of
interessant onderwerp. """
###

# -----------------------------------------------------------------------------
# Server-side rendering (docpad / coffeecup)
# -----------------------------------------------------------------------------
ctl = []
count = 0
videosLijst = @verzameling({relativeOutDirPath:'t-time/videos'},[date:-1])
nieuwsLijst = @verzameling({uitgave:$exists:true},[date:-1])
columnLijst = @verzameling({kenmerk:'ttColumn'})
speciaLijst = @verzameling({relativeOutDirPath:'t-time/specials/2012'},[date:-1])
knopGaNaarVideo = (nr) -> (li -> a '.ttVideoCtl--goto', 'data-goto': nr, href: '#', nr + 1)

# =============================================================================
# Videos (bovenste sectie, grijs)
# =============================================================================

section '#1.ttVideoSlider-sectie', ->

	h1 '.Tagline', 'Actuele videos'

	article '#ttSlideVideo.ttVideoSlider', ->

		for v in videosLijst
			ctl.push v.urls[0] # counter

			# Videos are images wrapped in a url. Revolver will slide them, Colorbox will open them
			a '.ttVideoSlide--open', href: "http://vimeo.com/#{v.vimeoId}", title: v.title, ->
				img ".ttVideoSlide #{if ctl.length isnt 0 then '.hidden'}"	, src: v.thumblarge

	# Video controle knoppen
	ul '.ttVideoCtl', ->

		# Ga naar <nr>
		knopGaNaarVideo nr for nr in [0...ctl.length]
		#li '.ttVideoCtl--play', -> a href: '#', 'Play'


# =============================================================================
# Nieuwsbrieven (groene sectie)
# =============================================================================

section '#2.ttNieuwsEditie-sectie', ->

	h1 '.Tagline', 'Onze nieuwsbrief'

	section '.ttNieuwsEditie-slider', ->

		for nb in nieuwsLijst

			a href: nb.urls[0], ->

				section '.ttNieuwsEditie-paneel', ->

					figure ->

						img src: "/media/afbeeldingen/icon_nieuwsbrief.png"
						figcaption "Nieuwsbrief #{nb.uitgave} #{nb.jaargang}"

						article '.ttNieuwsEditie', ->

							p 	'.ttNieuwsEditie-datum', nb.datum
							h3 	'.ttNieuwsEditie-titel', nb.subtitel
							img src: nb.illustratie

# =============================================================================
# Columns Marco Krijger
# =============================================================================
section '#3.ttColumnTegel-sectie', ->

	h1 '.ttColumnTegel-kop.Tagline', 'Columns van Marco Krijger'

	section '.ttColumnTegel-katern', ->

		for col in columnLijst

			count++

			#if count % 5 isnt 0 then console.log count
			if count < 5
				article '.ttColumnTegel-artikel', ->

					a href: col.urls[0], ->

						header ->
							img src: "/media/afbeeldingen/icon_column.png"
							h2 '.ttColumnTegel-titel'		, col.subtitel
							span '.ttColumnTegel-datum'		, col.datum
							p '.ttColumnTegel-samenvatting', col.samenvatting


# =============================================================================
# Specials
# =============================================================================

section '#4.ttSpecialSlider-sectie', ->

	h1 '.ttSpecialSlider-kop.Tagline', 'Specials van Tredius'

	section '.ttSpecialSlider-download', ->

		for spec in speciaLijst

			article '.ttSpecialSlider-artikel', ->
				a href: spec.bestand or '#', ->
					figure ->
						img src: "/media/afbeeldingen/icon_pdf.png"
						figcaption spec.titel
						img src: "/media/afbeeldingen/icon_download.png"

		ul '.ttSpecialCtl', ->
			li '.ttSpecialCtl-slide', -> a href: '#'



# xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
# Client-side scripts
# xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

script src: '/assets/jquery.revolver.min.js'

coffeescript ->

	# NOTE: I use $variable notation for global polutions
	# NOTE2: $ -> doesnt work
	$(document).ready ->

		# Videos --------------------------------------------------------------

		# Colorbox overlay (popup)
		$(".ttVideoSlide").colorbox(
			iframe:	true
			width: 	513
			height: 288
		)

		# Slider
		revolver = $('#ttSlideVideo').revolver(
			autoPlay: 			true
			rotationSpeed: 	5000
			slideClass: 		'ttVideoSlide'
			onReady: 			->
			onPlay: 			->
			onStop: 			->
			onPause: 			->
			onRestart: 		->
			transition:
				direction: 	'left'
				easing: 		'easeInQuad'
				type: 			'fade'
				onStart: 		->
				onComplete: 	->

		).data('revolver')

		# Leak revolver into the global namespace :(
		window.$revolver = revolver

		controls = $('.ttVideoCtl')

		controls.find(".first, .previous, .next, .last, .play, .stop, .pause, .restart").click (e) ->
			e.preventDefault()
			$revolver[@.className]()

		controls.find('.ttVideoCtl--goto').click (e) ->
			e.preventDefault()
			$revolver.goTo $(@).data('goto')

		#
		# Column (tegels) -----------------------------------------------------
		#
		container 	= $(".ttColumnTegel-katern")
		articles 	= container.children("article")
		timeout 	= 500

		articles.on "mouseenter", (event) ->
			article = $(this)
			clearTimeout timeout
			timeout = setTimeout(->
				return false  if article.hasClass("active")
				articles.not(article.removeClass("blur").addClass("active")).removeClass(
					"active").addClass "blur", 65)

		container.on "mouseleave", (event) ->
			clearTimeout timeout
			articles.removeClass "active blur"
