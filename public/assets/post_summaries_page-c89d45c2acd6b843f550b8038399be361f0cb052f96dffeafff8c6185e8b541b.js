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

    /* Collapse Button for Post Listings */
    const downChevron = "&#x25BC;";
    const upChevron = "&#x25B2;"
    const $collapseBtn = document.getElementById("collapseBtn");
    const $postList = document.getElementById("postList");
    const $postListingJumbotron = document.getElementById("postListingJumbotron");
    const $collapseInput = document.getElementById("collapse_state_list_collapsed");
    let collapsed = false;
    $collapseBtn.onclick = function() {
      if(collapsed) {
        $postList.classList.toggle("hidden");
        $postListingJumbotron.classList.toggle("collapsed");
        $collapseBtn.innerHTML = downChevron;
        $collapseInput.value = "false";
      } else {
        $postList.classList.toggle("hidden");
        $postListingJumbotron.classList.toggle("collapsed");
        $collapseBtn.innerHTML = upChevron;
        $collapseInput.value = "true";
      }
      collapsed = !collapsed;
    };

    if($collapseInput.value === "true") {
        $postList.classList.toggle("hidden");
        $collapseBtn.innerHTML = upChevron;
        collapsed = !collapsed;
    }
});
