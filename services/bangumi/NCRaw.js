// 不懂为什么同一时间api返回的数据不一样
// 有时候返回的是最新的，有时候返回的是稍微旧的

let regex = new RegExp('(孤獨搖滾|电锯人)');
let oldData
let minutes = 1
let the_interval = minutes * 60 * 1000;
let ID = process.env.ID
let TOKEN = process.env.TOKEN


async function init() {
    let res = await fetch('https://nc.raws.dev/0:/', { method: 'POST', body: JSON.stringify({ page_index: 0 }) });
    let json = await res.json();
    oldData = json.data.files
}

async function sendTG(name) {
    //change mp4 or mkv to zip
    let zipName = name.slice(0, -3) + "zip"
    let text = `
    <b>${name}</b>%0A
    <a href="http://bangumi.mlyxshi.com/?name=${zipName}">Open in Infuse</a>
    `
    await fetch(`https://api.telegram.org/bot${TOKEN}/sendMessage?chat_id=${ID}&parse_mode=html&text=${text}`)
}

async function main() {
    await init();
    setInterval(async () => {
        let res = await fetch('https://nc.raws.dev/0:/', { method: 'POST', body: JSON.stringify({ page_index: 0 }) });
        if (res.ok && res.status == 200) {
            let json = await res.json();
            let newData = json.data.files
            newData.forEach(newElement => {
                let newEntry = true

                oldData.forEach(oldElement => {
                    if (Date.parse(newElement.modifiedTime) <= Date.parse(oldElement.modifiedTime)) {
                        newEntry = false
                    }
                })

                if (newEntry) {
                    let episode = newElement.name
                    console.log(episode)
                    if (regex.test(episode)) {
                        sendTG(episode)
                    }
                }
            })

            if (Date.parse(newData[0].modifiedTime) > Date.parse(oldData[0].modifiedTime)) {
                oldData = newData;
            }

        } else {
            // Handle errors
            console.log(response.status, response.statusText);
        }


    }, the_interval);

}

main();
