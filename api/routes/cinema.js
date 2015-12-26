var express = require('express');
var request = require('request')
var MongoClient = require('mongodb').MongoClient;
var config = require('../config')
var url = config.url_api;
var url_cinema_api = config.url_cinema_api;
var router = express.Router();


/* GET cinema listing. */
router.get('/list', function (req, res, next) {
    MongoClient.connect(url, function (err, db) {
        var collection = db.collection('cinema');
        collection.find().count(function (err, count) {
            if (count == 0) {
                request({
                    url: url_cinema_api,
                    json: true
                }, function (error, response, body) {
                    if (!error && response.statusCode === 200) {
                        fieldList = [];
                        for (var i = 0; i < body['records'].length; i++) {
                            fieldList.push(body['records'][i].fields);
                        }
                        collection.insertMany(fieldList, function (error, inserted) {
                            collection.find({"ville": {$regex: ".*PARIS.*"}}).sort({ "adrcdpostal":-1 }).toArray(function (err, cinema) {
                                res.send(cinema);
                                db.close();
                            });
                        });
                    }
                })
            }
            else {
                collection.find({"ville": {$regex: ".*PARIS.*"}}).sort({ "adrcdpostal":1 }).toArray(function (err, cinema) {
                    res.send(cinema);
                    db.close();
                });
            }
        });
    });
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
