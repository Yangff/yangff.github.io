class Article
	constructor : (data, @render)->
		{@title, @symbol, @decs, @tags} = data
		@date = new Date(data.date)
		@content = false
		@mdData = null
		@display = false
		@loaded = false

	load : ->
		data =
			title: @title
			symbol: @symbol
			decs: @decs
			tags: @tags
			date: @date.getYear().toString() + "年 " + 	(@date.getMonth + 1).toString() + "月 " + @date.getDate().toString() + "日"
		html = @render(data)
		@content = $(html)
		$("#flow").append @content
		@loaded = true
		$.ajax("./pages/#{@symbol}/#{@symbol}.md").done(
			(data) =>
				@mdData = marked(data)
			@expend() if (@display)
		)

		@content.find(".opener").click =>
			if (@display)
				@display = false
				con = @content.find(".con")
				con.removeClass("ani");
				oldHeight = con.height();
				con.height("");
				con.html(@decs)
				openHeight = con.height();
				con.height(oldHeight)

				setTimeout(
					=>
						con.addClass("ani")
						con.height(openHeight)
					0
				)
			else
				@expend()

	expend : ->
		@display = true
		if (@mdData?)
			con = @content.find(".con")
			con.removeClass("ani");
			oldHeight = con.height();
			con.height("")
			con.html(@mdData)
			openHeight = con.height();
			con.height(oldHeight);

			setTimeout(
				=>
					con.addClass("ani")
					con.height(openHeight)
				0
			)

class Stage
	@articles : []
	@loadId : 0
	@onePage : 5
	@cleanUp: ->
		@loadId = 0
		@articles = []
		$("#flow").html("")

	@render: false
	@busy: false

	@nextPage: ->
		return if (@busy)
		return if (@loadId == @articles.length)
		@busy = true
		@articles[i].load() for i in [@loadId...Math.min(@loadId + @onePage, @articles.length)]
		@loadId = Math.min(@loadId + @onePage, @articles.length)
		@busy = false

	@init :->
		@render = baidu.template("tpl_well")
		$.ajax("./pages/contents.json",{dataType:"json"}).done(
			(data)=>
				@cleanUp()
				@articles = (new Article(article, @render) for article in data)
				@nextPage()
		)


		# bind action

		$("[data-toggle=change-skirt]").click =>
			if (window.skirt == "flatly")
				window.skirt = "cyborg";
			else if (window.skirt == "cyborg")
				window.skirt = "flatly";
			href = "https://netdna.bootstrapcdn.com/bootswatch/3.0.3/" + window.skirt + "/bootstrap.min.css"
			$("#sty")[0].href = href
			console.log window.skirt

		$(window).bind(
			'scroll'
			=>
				@nextPage() if ($(document).scrollTop() + $(window).height() > $(document).height() - 20)
		)
		renderer = new marked.Renderer()
		renderer.heading = (text, level) ->
		  	return "<h#{level+3}>#{text}</h#{level+3}>";

		marked.setOptions
		  renderer: renderer,
		  gfm: true,
		  tables: true,
		  breaks: true,
		  pedantic: false,
		  sanitize: false,
		  smartLists: true,
		  smartypants: true

Stage.init()
