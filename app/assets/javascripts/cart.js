function updateTaxes() {
  const province = document.querySelector('[name="province"]').value;
  fetch(`/cart/update_taxes?province=${province}`)
    .then(response => response.json())
    .then(data => {
      document.getElementById('gst').innerText = data.gst.toFixed(2);
      document.getElementById('pst').innerText = data.pst.toFixed(2);
      document.getElementById('hst').innerText = data.hst.toFixed(2);
      document.getElementById('subtotal').innerText = data.subtotal.toFixed(2);
      document.getElementById('total').innerText = data.total.toFixed(2);
    })
    .catch(error => console.error('Error updating taxes:', error));
}

// Expose to global scope
window.updateTaxes = updateTaxes;