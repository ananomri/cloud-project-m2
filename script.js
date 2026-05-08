// ⚠️ La variable API_URL est injectée par Terraform (DNS de l'ALB)
// Si vous avez une build front séparée, remplacez par : http://<ALB_DNS>
const API_URL = `http://${window.__ALB_DNS__ || 'REPLACE_WITH_ALB_DNS'}`;


async function checkHealth() {
    try {
        const res = await fetch(`${API_URL}/health`);
        const data = await res.json();
        const statusDiv = document.getElementById('status');
        const infoDiv = document.getElementById('instance-info');

        statusDiv.className = 'status-ok';
        statusDiv.textContent = `Backend opérationnel`;
    } catch (err) {
        const statusDiv = document.getElementById('status');
        statusDiv.className = 'status-error';
        statusDiv.textContent = ` Backend inaccessible!! - ${err.message}`;
    }
}

async function loadMessages() {
    try {
        const res = await fetch(`${API_URL}/api/messages`);
        const data = await res.json();
        const container = document.getElementById('messages');

        if (!data.success || data.data.length === 0) {
            container.innerHTML = '<p>Aucun message pour le moment.</p>';
            return;
        }

        container.innerHTML = data.data.map(msg => `
            <div class="message-item">
                <div class="message-author">${msg.author}</div>
                <div class="message-content">${msg.content}</div>
                <div class="message-date">${new Date(msg.created_at).toLocaleString()}</div>
            </div>
        `).join('');
    } catch (err) {
        document.getElementById('messages').innerHTML = `<p class="status-error">Erreur: ${err.message}</p>`;
    }
}

document.getElementById('messageForm').addEventListener('submit', async (e) => {
    e.preventDefault();
    const author = document.getElementById('author').value;
    const content = document.getElementById('content').value;

    try {
        const res = await fetch(`${API_URL}/api/messages`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ author, content })
        });
        const data = await res.json();

        if (data.success) {
            document.getElementById('messageForm').reset();
            loadMessages();
        } else {
            alert('Erreur: ' + data.error);
        }
    } catch (err) {
        alert('Erreur réseau: ' + err.message);
    }
});

// Chargement initial
checkHealth();
loadMessages();
setInterval(checkHealth, 10000);
