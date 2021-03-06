
<%@ include file="includes/global_header.jsp" %>
<%@page import="java.util.Vector"%>
<% 

// You need list of projects
 Vector<Project> projects = JDBCDriver.getProjects();

%>
<!-- Browse Projects Page or Home Page -->

<div style="margin-top: 25px;">
	<div id="title1"> Listen </div>
	<div id="title2"> Up </div>
</div>
<!-- SEARCH -->
<input type="text" class="quicksearch" placeholder="Search" />


<div id="sortTitle">
<p>Sort By</p></div>
<div id="sorts" class="clickable">  
  <button class="button is-checked" data-sort-by="original-order">Original Order</button>
  <button class="button" data-sort-by="vote">Most Popular</button>
  <button class="button" data-sort-by="name">Name</button>
  <button class="button" data-sort-by="date">Date</button>  
</div>  


<div id="filterTitle">
	<p>Filter By</p></div> 
<div id="genreTitle">
	<p>Genre</p></div> 
<div id="filters" class="button-group clickable">  
  <button class="button is-checked" data-filter="*">show all</button>
  <button class="button" data-filter=".jazz">Jazz</button>
  <button class="button" data-filter=".rock">Rock</button>
  <button class="button" data-filter=".kpop">Kpop</button>
  <button class="button" data-filter=".classical">Classical</button>
</div> 


 <div class="grid">
 <%
	for(Project project : projects){	 
 %>
	 <div class="element-item <%= project.getGenre() %>" data-category=<%= project.getGenre() %> >
	 <p class="name"> <a href="auditionstage.jsp?project=<%=project.getId()%>"> <%= project.getName() %></a></p>
	 <p class="date">Date: <%= project.getCreateDate() %></p>
	 <!-- <p><i class="arrow up"></i></p> -->
	 <a href="#" onclick="addProjectLike(<%=project.getId()%> , <%= (u == null) ? -1 : u.get_id() %>)"><img id="arrow" src="images/vote_blue.png" /></a>
	 
	 <p id="project_vote_<%=project.getId()%>" class="v vote"> <%= project.getUpvoteCount() %></p>    
	 
	 <p class="genre">Genre: <%= project.getGenre() %></p>    
	</div>

<%
	}
 %>  
 </div>
 
<script>
	var buttonFilter;

	var $grid = $('.grid').isotope({
	itemSelector: '.element-item',
	layoutMode: 'fitRows',
	getSortData: {
	 name: '.name',
	 date: '.date',
	 vote: '.vote parseInt',
	 category: '[data-category]'
	},
	sortAscending: {
		name: true,
		 date: true,
		 vote: false,
		 category: true
	},
	filter: function() {
	    var $this = $(this);
	    var searchResult = qsRegex ? $this.text().match( qsRegex ) : true;
	    var buttonResult = buttonFilter ? $this.is( buttonFilter ) : true;
	    return searchResult && buttonResult;
	}
	});
	
	//filter functions
	var filterFns = {
	// show if number is greater than 50
	numberGreaterThan50: function() {
	 var number = $(this).find('.number').text();
	 return parseInt( number, 10 ) > 50;
	},
	// show if name ends with -ium
	ium: function() {
	 var name = $(this).find('.name').text();
	 return name.match( /ium$/ );
	}
	};
	
	//bind filter button click
/* 	$('#filters').on( 'click', 'button', function() {
	var filterValue = $( this ).attr('data-filter');
	// use filterFn if matches value
	filterValue = filterFns[ filterValue ] || filterValue;
	$grid.isotope({ filter: filterValue });
	}); */
	
	$('#filters').on( 'click', 'button', function() {
		  buttonFilter = $( this ).attr('data-filter');
		  $grid.isotope();
	});
	
	//bind sort button click
	$('#sorts').on( 'click', 'button', function() {
	var sortByValue = $(this).attr('data-sort-by');
	$grid.isotope({ sortBy: sortByValue });
	});
	
	//change is-checked class on buttons
	$('.clickable').each( function( i, buttonGroup ) {
	var $buttonGroup = $( buttonGroup );
	$buttonGroup.on( 'click', 'button', function() {
	 $buttonGroup.find('.is-checked').removeClass('is-checked');
	 $( this ).addClass('is-checked');
	 
	if($('#mainBody').height() < 625) {
		$('#footer').addClass('down');
	} else {
		$('#footer').removeClass('down');
	}
	});
	});


	// quick search regex
	var qsRegex;

	// init Isotope
/* 	var $grid = $('.grid').isotope({
	  itemSelector: '.element-item',
	  layoutMode: 'fitRows',
	  filter: function() {
	    return qsRegex ? $(this).text().match( qsRegex ) : true;
	  }
	}); */

	// use value of search field to filter
	var $quicksearch = $('.quicksearch').keyup( debounce( function() {
	  qsRegex = new RegExp( $quicksearch.val(), 'gi' );
	  $grid.isotope();
	  
	if($('#mainBody').delay(100).height() < 625) {
		$('#footer').addClass('down');
	} else {
		$('#footer').removeClass('down');
	}
	}, 200 ) );

	// debounce so filtering doesn't happen every millisecond
	function debounce( fn, threshold ) {
	  var timeout;
	  return function debounced() {
	    if ( timeout ) {
	      clearTimeout( timeout );
	    }
	    function delayed() {
	      fn();
	      timeout = null;
	    }
	    timeout = setTimeout( delayed, threshold || 100 );
	  }
	}
</script>

<%@ include file="includes/global_footer.jsp" %>		