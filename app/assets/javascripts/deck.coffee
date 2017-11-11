# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/




$( document ).ready(function() {

	var $container = document.getElementById('container');
	var deck = Deck();

	// Select the first card
	var card = deck.cards[11];

	// Add it to an html container
	card.mount($container);

	// Allow to move/drag it
	card.enableDragging();

	// Allow to flip it
	card.enableFlipping();
});

