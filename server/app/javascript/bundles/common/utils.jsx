export function id(id, value) {
    return `${id}-${value}`
}

export function digitFilter(event, allowDots = false) {
    let doNotFilter = (allowDots && event.charCode === 46) || event.charCode >= 48 && event.charCode <= 57;

    if (!doNotFilter) {
        event.preventDefault();
    }

    return doNotFilter;
}