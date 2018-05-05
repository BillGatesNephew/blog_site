$(document).ready(function() {
    const badgeColors = ["badge-primary", "badge-secondary", "badge-info", "badge-success", "badge-dark", "badge-light"];
    const tagDiv = document.getElementById("tags");

    let badgeCount = 5;

    function addTagToRow(tagName) {
        const newTag = createTag(tagName);
        tagDiv.appendChild(newTag);
        badgeCount = (badgeCount == 5) ? 0 : badgeCount + 1;
    }

    function createTag(tagName) {
        let tag = document.createElement("span");
        tag.setAttribute("class", "badge tag-badge " + badgeColors[badgeCount]);
        let content = document.createTextNode(tagName);
        tag.appendChild(content);
        return tag;
    }

    addTagToRow("Complexity Theory");
    addTagToRow("Clean Code");
    addTagToRow("Complexity Theory");
    addTagToRow("Clean Code");
    addTagToRow("Complexity Theory");
    addTagToRow("Clean Code");
    addTagToRow("Complexity Theory");
    addTagToRow("Clean Code");

});