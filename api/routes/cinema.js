var async = require("async");
var express = require('express');
var request = require('request')
var MongoClient = require('mongodb').MongoClient;
var config = require('../config')
var url = config.url_api;
var url_cinema_api = config.url_cinema_api;
var router = express.Router();
var stats = require('./stats');


var fillDatabase = function (db, callback) {
    var collection = db.collection('cinema');
    request({
        url: url_cinema_api,
        json: true
    }, function (error, response, body) {
        if (!error && response.statusCode === 200) {
            fieldList = [];
            for (var i = 0; i < body['records'].length; i++) {
                fieldList.push(body['records'][i].fields);
            }
            collection.insertMany(fieldList);
            callback();
        }
    });
};

var isEmptyDatabase = function (db, callback) {
    var collection = db.collection('cinema');

    collection.find().count(function (err, count) {
        callback(count == 0 ? true : false);
    });
}

/* GET cinema listing. */
router.get('/list', function (req, res, next) {
    MongoClient.connect(url, function (err, db) {
        async.waterfall([
                function (callback) {
                    isEmptyDatabase(db, function (isEmpty) {
                        if (isEmpty) {
                            fillDatabase(db, function () {
                                stats.getAverageCinema(db, function (full) {
                                    callback(null, db, full);
                                });
                            });
                        }
                        else {
                            stats.getAverageCinema(db, function (full) {
                                callback(null, db, full);
                            });
                        }
                    });
                }
            ],
            function (err, db, full) {
                res.send(full);
                db.close();
            }
        )
        ;
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
