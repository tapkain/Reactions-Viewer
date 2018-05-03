/**
 * Created by Dušan Brejka on 07/03/2018.
 */

let fs = require('fs');
let path = require('path');
let processDir = process.cwd();
let args = process.argv;
args.shift();
args.shift();

let swaggerFile = args && args.shift() || 'swagger.json';
let isProduction = false;

function getModelJson(filename) {
    return new Promise(function(resolve, reject) {
        fs.readFile(filename, { encoding: 'utf8', flag: 'r' }, (err, contents) => {
            if(err) return reject(err);
            if(contents) {
                return resolve(JSON.parse(contents));
            } else return resolve(false);
        });
    });
}

function writeSwaggerFile(definition, filename, uglyfi = false) {
    return new Promise(function(resolve, reject) {
        definition = JSON.stringify(definition, null, uglyfi ? null : '\t');
        fs.writeFile(path.join(processDir, filename), definition, { encoding: 'utf8', flag: 'w' }, (err) => {
            if(err) return reject(err);
            return resolve(true);
        });
    });
}

console.log('SwaggerFix: started');
getModelJson(swaggerFile).then(swaggerContents => {
    let recursiveRefReplace = input => {
        if(input && typeof input === "object") {
            if(input["$ref"]) {
                input["$ref"] = input["$ref"].replace(/^{{model:\s?(\w+)}}$/, "#/definitions/$1");
                let modelName = input["$ref"].match(/^#\/definitions\/(\w+)$/).pop();
                if(swaggerContents.definitions && swaggerContents.definitions[modelName] && ['string', 'integer', 'number'].includes(swaggerContents.definitions[modelName].type)) {
                    input = swaggerContents.definitions[modelName];
                }
            } else if(Array.isArray(input)) {
                for(let i = 0, l = input.length; i < l; i++) {
                    input[i] = recursiveRefReplace(input[i]);
                }
            } else {
                Object.keys(input).forEach(k => {
                    input[k] = recursiveRefReplace(input[k]);
                });
            }
        }
        return input;
    };
    return recursiveRefReplace(swaggerContents);
}).then(swaggerContents => {
    return writeSwaggerFile(swaggerContents, swaggerFile, isProduction);
}).then(o => {
    console.log('SwaggerFix: finished');
}).catch(e => {
    console.log(e);
});