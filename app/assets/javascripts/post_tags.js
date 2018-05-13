let addTagToDropdown;
$(document).ready(function() {
    const badgeColors = [
        "badge-primary", "badge-info", "badge-success", "badge-dark", "badge-light"
    ];
    const $tagDiv = document.getElementById("tags");
    const $dropdown = document.getElementById("dropdownMenu");
    const $tagInput = document.getElementById("tagInput");

    let badgeCount = 0;
    let dropdownTags = [];
    let rowTags = [];

    addTagToDropdown = function(tagName) {
        const $tagLink = createElement("a", tagName, "dropdown-item");
        $tagLink.onclick = () => {
            if(!rowTags.includes(tagName)) {
                addTagToRow(tagName);
                dropdownTags = dropdownTags.filter(item => item !== tagName);
                updateTagInputValue();
            }
        };
        $dropdown.prepend($tagLink);
        dropdownTags.push(tagName);
    }

    function addTagToRow(tagName) {
        const classString = "badge tag-badge " + badgeColors[badgeCount];
        const $newTag = createElement("span", tagName + " \u00A0", classString);
        $newTag.setAttribute("id", tagName);
        const $tagDelete = createElement("a", "X", "badge badge-pill badge-danger remove-tag");
        $tagDelete.onclick = () => {
            const $tag = document.getElementById(tagName);
            rowTags = rowTags.filter(item => item !== tagName);
            $tag.remove();
            updateTagInputValue();
        }
        $newTag.appendChild($tagDelete);
        $tagDiv.appendChild($newTag);
        rowTags.push(tagName);
        badgeCount = (badgeCount == 5) ? 0 : badgeCount + 1;
    }

    function createElement(elementType, elementText, elementClass) {
        let $element = document.createElement(elementType);
        $element.setAttribute("class", elementClass);
        let $text = document.createTextNode(elementText);
        $element.appendChild($text);
        return $element;
    }   

    function updateTagInputValue() {
        document.getElementById("post_tags").value = rowTags;
    }

    $tagInput.onkeypress = function(event) {
        const inputString = $tagInput.value + event.key;
    }

    initialTags.forEach(addTagToDropdown);
    currentTags.forEach(addTagToRow);


    document.addEventListener("trix-change", function(event) {
        let editorContent = $("trix-editor").first()[0].value;
        editorContent = editorContent.replace(/&lt;/g, "<");
        editorContent = editorContent.replace(/&gt;/g, ">");
        document.getElementById("contentPreview").innerHTML = "";
        document.getElementById("contentPreview").innerHTML = editorContent;
    });
    
});