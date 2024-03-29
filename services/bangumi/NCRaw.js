// 不懂为什么同一时间api返回的数据不一样
// 有时候返回的是最新的，有时候返回的是稍微旧的

let regex = /(孤獨搖滾.*Baha|电锯人)/;
let oldData
let minutes = 1
let the_interval = minutes * 60 * 1000;
let ID = process.env.ID
let TOKEN = process.env.TOKEN

async function sendTG(name) {
    //change mp4 or mkv suffix to zip
    let zipName = name.slice(0, -3) + "zip"
    let text = `<b>${name}</b>%0A<a href="http://bangumi.mlyxshi.com/?name=${zipName}">Open in Infuse</a>`  //telegram open link will auto encode
    await fetch(`https://api.telegram.org/bot${TOKEN}/sendMessage?chat_id=${ID}&parse_mode=html&text=${text}`)
}

async function init() {
    let res = await fetch('https://nc.raws.dev/0:/', { method: 'POST', body: JSON.stringify({ page_index: 0 }) });
    let json = await res.json();
    oldData = json.data.files

    oldData.forEach(element => {
        let episode = element.name
        console.log(episode)
        if (regex.test(episode)) {
            sendTG(episode)
        }
    })
}

async function main() {
    await init();
    setInterval(async () => {
        try {
            let res = await fetch('https://nc.raws.dev/0:/', { method: 'POST', body: JSON.stringify({ page_index: 0 }) });

            if (res.status == 200) {
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

            }

        } catch (err) {
            console.log(err)
        }

    }, the_interval);

}

main();
