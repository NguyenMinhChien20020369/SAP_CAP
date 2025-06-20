module.exports = srv => {

    console.log(`Service name: ${srv.name} is served at ${srv.path}`);
    
    srv.after('READ', 'Books', xs => {
        console.log(xs);
        
        const newBooks = []
        xs.forEach(x => {
            if (x.stock > 500) {
                x.title = '(10% off!) ' + x.title
            }
            newBooks.push(x)
        });
        console.log(newBooks);
        return newBooks
    })

}