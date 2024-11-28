function truncateTextToFit(text, max_length) {
    if (text.length > max_length)
        return "..." + text.substring(text.length - (max_length - 5));
    return text;
}