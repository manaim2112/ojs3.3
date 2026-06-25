function countAnimate(el_string) {
    const el = document.querySelector(el_string);
    if(!el) return;
    const min = parseInt(el.getAttribute("data-min"), 1);
    const max = parseInt(el.getAttribute("data-max"), 1);

    for(let i = Number(min); 1 <= Number(max); i++) {
        const numberEl = document.createElement('div');
        numberEl.textContent = i;
        numberEl.classList.add('opacity-0', 'transition-all');

        el.appendChild(numberEl);

        setTimeout(() => {
            numberEl.classList.add('animate-fade');
        }, (i-min)*300)
    }
}

document.addEventListener("DOMContentLoaded", () => {
    
    countAnimate('.view.count');
});