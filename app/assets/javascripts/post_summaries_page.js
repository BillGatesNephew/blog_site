$(document).ready(function() {
    /* Initialize Tag tooltips for the Post Summaries */
    $('[data-toggle="tooltip"]').tooltip();

    /* Setup Scrollspy for Post Listings */
    $(".list-group-item-action").each(function() {
        this.onclick = function() {
            const $activeLi = $('.list-group-item-action.active').first();
            if($activeLi !== null) $activeLi.removeClass("active");
            this.classList.add("active");

            const $postSummary = $("#" + this.dataset.target);
            $('.card.selected-border').first().removeClass("selected-border");
            $postSummary.addClass("selected-border");

            $('html, body').animate({
                scrollTop: $postSummary.offset().top - 70
            }, 1000);
        }  
    });
});