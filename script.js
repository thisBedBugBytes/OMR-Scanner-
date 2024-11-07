// JavaScript to toggle between light and dark modes
document.getElementById('light-mode-btn').addEventListener('click', () => {
    document.body.classList.add('light-mode');
    document.body.classList.remove('dark-mode');
});

document.getElementById('dark-mode-btn').addEventListener('click', () => {
    document.body.classList.add('dark-mode');
    document.body.classList.remove('light-mode');
});