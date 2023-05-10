const express = require('express')
const router = express.Router()
const aws = require('aws-sdk')

const credentials = new aws.SharedIniFileCredentials({profile: 'default'})
aws.config.credentials = credentials

const ddb = new aws.DynamoDB({region: 'us-east-1'})

router.get('/', (req, res) => {
    //Obtener datos de dynamoDB
    var electrolineras_prom = ddb.scan({
        TableName: 'Electrolinera'
    }).promise()

    var puntoscarga_prom = ddb.scan({
        TableName: 'PuntoCarga'
    }).promise()

    Promise.all([electrolineras_prom, puntoscarga_prom]).then((values) => {
        res.render('index/index', {
            electrolineras: values[0].Items,
            puntoscarga: values[1].Items
        })
    })
})

module.exports = router;