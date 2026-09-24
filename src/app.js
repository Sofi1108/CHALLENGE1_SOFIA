const filters = document.querySelectorAll(".filter");
const cards = document.querySelectorAll(".event-card");
const searchInput = document.querySelector("#searchInput");
const resetButton = document.querySelector("#resetButton");
const emptyState = document.querySelector("#emptyState");
const subscribeForm = document.querySelector("#subscribeForm");
const formMessage = document.querySelector("#formMessage");

let activeFilter = "Todos";

function updateEvents() {
  const searchTerm = searchInput.value.trim().toLowerCase();
  let visibleCards = 0;

  cards.forEach((card) => {
    const matchesFilter =
      activeFilter === "Todos" || card.dataset.category === activeFilter;
    const matchesSearch = card.dataset.search.includes(searchTerm);
    const shouldShow = matchesFilter && matchesSearch;

    card.classList.toggle("is-hidden", !shouldShow);
    if (shouldShow) visibleCards += 1;
  });

  emptyState.hidden = visibleCards > 0;
}

filters.forEach((filter) => {
  filter.addEventListener("click", () => {
    activeFilter = filter.dataset.filter;
    filters.forEach((item) =>
      item.classList.toggle("is-active", item === filter),
    );
    updateEvents();
  });
});

searchInput.addEventListener("input", updateEvents);

resetButton.addEventListener("click", () => {
  activeFilter = "Todos";
  searchInput.value = "";
  filters.forEach((filter) =>
    filter.classList.toggle("is-active", filter.dataset.filter === "Todos"),
  );
  updateEvents();
  document.querySelector("#eventos").scrollIntoView({ behavior: "smooth" });
});

subscribeForm.addEventListener("submit", (event) => {
  event.preventDefault();
  formMessage.textContent = "Listo. Revisa tu bandeja de entrada.";
  subscribeForm.reset();
});
