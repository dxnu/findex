function truncateTextToFit(text, max_length) {
    return text.length > max_length
        ? "..." + text.substring(text.length - (max_length - 5))
        : text;
}