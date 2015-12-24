var express = require('express');
var MongoClient = require('mongodb').MongoClient;
var config = require('../config')
var url = config.url_api;
var router = express.Router();
var stats = require('./stats');

/* Add room */
router.get('/add/:idcinema/:roomname', function (req, res, next) {
    var id = req.params.idcinema;
    var name = req.params.roomname;

    if (id == null || name == null) {
        res.send({"error": "arguments"});
        return;
    }

    MongoClient.connect(url, function (err, db) {
        db.collection('room').find({'idcinema': id, 'roomname': name.toLowerCase()}).count(function (_, count) {
            if (count > 0) {
                db.close();
                res.send({"error": "rooms already exist"});
            }
            else {
                db.collection('room').insert({'idcinema': id, 'roomname': name})
                db.close();
                res.send({"error": "ok", "inserted": {"idcinema": id, "roomname": name}});
            }
        });
    });
});

/* Get all rooms */
router.get('/list', function (req, res, next) {
    MongoClient.connect(url, function (err, db) {
        db.collection('room').find().toArray(function (err, doc) {
            db.close();
            res.send(doc);
        });
    })
});


/* Get rooms of cinema */
router.get('/list/:idcinema', function (req, res, next) {
    var id = req.params.idcinema;

    if (id == null) {
        res.send({"error": "arguments"});
        return;
    }

    stats.getAverageComments(id, function(full) {
        res.send(full);
    })

});


/* Drop rooms */
router.get('/drop', function (req, res, next) {
    MongoClient.connect(url, function (err, db) {
        db.collection('room').drop();
        db.close();
        res.send({"error": "ok"});
    });
})

module.exports = router;