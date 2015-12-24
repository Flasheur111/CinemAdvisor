var async = require("async");
var express = require('express');
var MongoClient = require('mongodb').MongoClient;
var config = require('../config')
var url = config.url_api;

module.exports = {
    getAverageComments: function (id, cb) {
        async.waterfall([
            function (callback) {
                MongoClient.connect(url, function (err, db) {
                    db.collection('room').find({"idcinema": id}).toArray(function (err, document) {
                        callback(err, db, document);
                    });
                });
            },
            function (db, document, callback) {
                var full = [];
                if (document.length > 0) {
                    async.forEach(document, function (doc, callback2) {
                        db.collection('comment').find({
                            'idcinema': id,
                            'idroom': doc._id.toString()
                        }).toArray(function (err, out) {
                            var items = [];
                            var sum = 0;
                            if (out) {
                                for (var i = 0; i < out.length; i++) {
                                    if (out[i]) {
                                        items.push(out[i].grade);
                                        sum += out[i].grade;
                                    }
                                }
                                var avg = sum / items.length;
                                doc.avg = avg ? avg : 0;
                            }
                            else
                                doc.avg = 0;

                            full.push(doc);
                            if (document[document.length - 1]._id == doc._id)
                                callback(null, db, full);
                        });
                    });
                }
                else {
                    callback(null, db, [])
                }

            }
        ], function (err, db, full) {
            db.close();
            cb(full);
        });
    }
}
