var express = require('express');
var request = require('request')
var MongoClient = require('mongodb').MongoClient;
var url = 'mongodb://localhost:27017/test';
var router = express.Router();

var urlapi = 'http://data.iledefrance.fr/api/records/1.0/search/?dataset=les_salles_de_cinemas_en_ile-de-france&facet=dep&facet=adrcommune'

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
                for (var i = 0; i < body['records'].length; i++){
                    db.collection('cinema').insert(body['records'][i].fields);
                }

            }
        })
    });
    res.send('insert done');
});

/* DROP all the cinema. */
router.get('/drop', function (req, res, next) {
    MongoClient.connect(url, function (err, db) {
        db.collection('cinema').drop();
        res.send('All cinema dropped');
    });
});

module.exports = router;
