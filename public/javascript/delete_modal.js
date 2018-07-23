let triggers = document.querySelectorAll('.trigger');
let modals = document.querySelectorAll('.custom-modal');
let modalBackground = document.querySelector('.custom-modal-background');
let closeButtons = document.querySelectorAll('.close-button');

triggers.forEach(function(trigger) {
    let trigger_id = trigger.getAttribute('id');
    let category_id = trigger_id.split('-')[1];
    trigger.addEventListener("click", function() {
        let modal_id = '#modal-category-' + category_id;
        let active_modal = document.querySelector(modal_id);

        console.log(modal_id);

        for(let modal of modals) {
            modal.classList.remove('show-modal');
            modalBackground.classList.remove('show-modal');
        }

        console.log(active_modal.getAttribute('id'));
        active_modal.classList.add('show-modal');
        modalBackground.classList.add('show-modal');
    });
});

closeButtons.forEach((closeButton) => {
    closeButton.addEventListener("click", () => {
        for (let modal of modals) {
            modal.classList.remove('show-modal');
            modalBackground.classList.remove('show-modal');
        }
    });
});




console.log("Boom");
