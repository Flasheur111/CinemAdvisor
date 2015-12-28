var async = require("async");
var express = require('express');
var MongoClient = require('mongodb').MongoClient;
var config = require('../config')
var stats = require('./stats')
var url = config.url_api;


exports.getAverageComments = function (id, db, cb) {
    async.waterfall([
        function (callback) {
            db.collection('room').find({"idcinema": id}).toArray(function (err, document) {
                callback(err, document);
            });
        },
        function (document, callback) {
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
                            callback(null, full);
                    });
                });
            }
            else {
                callback(null, [])
            }

        }
    ], function (err, full) {
        cb(full);
    });
};

exports.getAverageCinema = function (db, cb) {
    async.waterfall([
            function (callback) {
                db.collection('cinema').find({"ville": {$regex: ".*PARIS.*"}}).toArray(function (err, cinema) {
                    callback(err, cinema);
                });
            },
            function (document, callback) {
                var full = [];

                async.forEach(document, function (doc) {
                    stats.getAverageComments(doc.noauto.toString(), db, function (comments) {
                        var sum = 0;
                        if (comments != null && comments.length > 0) {
                            for (var i = 0; i < comments.length; i++) {
                                sum += comments[i].avg;

                                if (comments[comments.length - 1]._id == comments[i]._id) {
                                    doc.avg = sum / comments.length;
                                    full.push(doc);
                                }
                            }
                        }
                        else {
                            doc.avg = 0;
                            full.push(doc);
                        }
                        if (document[document.length - 1]._id == doc._id) {
                            callback(null, full);
                        }
                    });
                });
            }
        ],

        function (err, full) {
            var sorted = full.sort(function (a,b) {
               return a.adrcdpostal - b.adrcdpostal;
            });
            cb(full);
        }
    )
    ;
}
;
