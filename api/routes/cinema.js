var express = require('express');
var request = require('request')
var MongoClient = require('mongodb').MongoClient;
var url = 'mongodb://localhost:27017/test';
var router = express.Router();

var urlapi = 'http://data.iledefrance.fr/api/records/1.0/search/?dataset=les_salles_de_cinemas_en_ile-de-france&rows=309'

/* GET cinema listing. */
router.get('/', function (req, res, next) {

    MongoClient.connect(url, function (err, db) {
        db.collection('cinema').find().toArray(function (err, cinema) {
            res.send(cinema);
        });
    });
});

router.get('/init', function(req, res, next) {
    MongoClient.connect(url, function (err, db) {
        request({
            url: urlapi,
            json: true
        }, function (error, response, body) {
            if (!error && response.statusCode === 200) {
                console.log(body['records'].length);
                fieldList = [];
                for (var i = 0; i < body['records'].length; i++){
                    fieldList.push(body['records'][i].fields);
                }
                console.log(fieldList.length);
                db.collection('cinema').insertMany(fieldList);
                db.close();
            }
        })
    });
    res.send('insert done');
});

/* DROP all the cinema. */
router.get('/drop', function (req, res, next) {
    MongoClient.connect(url, function (err, db) {
        db.collection('cinema').drop();
        db.close();
        res.send('All cinema dropped');
    });
});

module.exports = router;
