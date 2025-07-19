document.addEventListener('DOMContentLoaded', function() {
    // Simulate loading server information
    setTimeout(function() {
        document.getElementById('server-id').textContent = 'i-' + generateRandomId();
        document.getElementById('region').textContent = 'us-east-1';
        document.getElementById('deploy-time').textContent = new Date().toLocaleString();
    }, 1000);
    
    // Generate a random server ID
    function generateRandomId() {
        return Math.random().toString(36).substring(2, 10);
    }
});
