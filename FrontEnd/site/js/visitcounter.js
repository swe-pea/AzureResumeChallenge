$(function() {
    // Fetch the configuration JSON file
    fetch('/config.json')
       .then(response => response.json())
       .then(config => {
            // Check if the visitor has been counted before
            const hasBeenCounted = localStorage.getItem('hasBeenCounted');

            if (!hasBeenCounted) {
                // Make a POST request to increment the visitor count
                var incrementOptions = {
                    method: 'POST',
                    redirect: 'follow'
                };
            
                fetch(`${config.apiEndpoint}/api/VisitorCount?clientId=default`, incrementOptions)
                .then(response => response.text())
                .then(result => {
                        console.log(result);
                        // Mark the visitor as counted
                        localStorage.setItem('hasBeenCounted', true);
                })
                .catch(error => console.log('Error incrementing site views count:', error));
            }

            // Make a GET request to fetch and display the visitor count
            var requestOptions = {
                method: 'GET',
                redirect: 'follow'
            };
                
            fetch(`${config.apiEndpoint}/api/VisitorCount?clientId=default`, requestOptions)
            .then(response => response.text())
            .then(result => {
                    console.log(result);
                    document.getElementById("siteViewsCount").innerHTML = result;
                }) 
            .catch(error => console.log('Error fetching site views count:', error));
       })
       .catch(error => console.log('Error fetching configuration:', error));
});