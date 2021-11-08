# SICOMO Radiochannel Project

To estimate propagation losses, computer tools are used that incorporate theoretical, empirical or semi-empirical electromagnetic models that can be applied in a frequency band 
and in an environment (rural, urban, suburban or indoor). These models need to be validated by performing measurement campaigns in the environments and in the corresponding 
frequency bands. The purpose of the project is the development of an App in Matlab to carry out telecommunications channel measures and, once the application was developed,
to demonstrate the applicability of the Walfisch-Bertoni urban propagation model for path loss estimation in citrus plantations at 3.5 GHz by using the app and scripting the 
results.

## Main files 🗂

"sicomo.m" -> Logic of the App.
"sicomo.fig" -> Interface of the App.
"ditancia.m" -> Received power as a function of distance from the transmitter.
"angulo.m" -> It calculates the received power as a function of the angle with respect to the transmitter.


## Starting 🚀

_To get started you will need to download Matlab R2017b, whose link can be found in Prerequisites._

See **Deployment** to know how to deploy the project.

## build with 🛠️

* [MATLAB R2017b](https://es.mathworks.com/campaigns/products/trials.html?ef_id=Cj0KCQjw8p2MBhCiARIsADDUFVFEihuTYVBFAEFeiMFJe9wna2m5IM-8cgsttCVmTuGSx-QZxr7Y6nEaAnf3EALw_wcB:G:s&s_kwcid=AL!8664!3!252706741089!p!!g!!matlab%20descargar&s_eid=ppc_27405573562&q=matlab%20descargar&gclid=Cj0KCQjw8p2MBhCiARIsADDUFVFEihuTYVBFAEFeiMFJe9wna2m5IM-8cgsttCVmTuGSx-QZxr7Y6nEaAnf3EALw_wcB) - software use for development

## Deploy 📦 and use 🎛

If you want to modify some of the code bear in mind how to works Matlab Guide. Please find information about it in my final project paper.
_1. Download the project and open it in MATLAB by clicking "Open" > "Open..."._

_2. Go to sicomo.m_

_3. Type the IP of your Anritsu device in the section "Instrument Connection" (lines 159 and 165)._

_4. Press the "Run" buttom located on top of the Matlab aplication._

_5. A window called "sicomo" will open. Fill in the blanks and pulse "Conect"._

_6. You can now click "start drive test" to initiate the automatic take of measures._

_7. When you have finished your campaign (or you want to pause it) click "pause drive test" and then click “save”. After that see how the Command Window of Matlab asks you to enter
   a name for your campaing. BE SURE to enter it and press "enter" in your keyword. The campaign will save in your Current Matlab folder._
   
_8. If you want to make another campaing with the same parameter BE SURE to click the buttom "Conect" again before press “start dive testing”, just in case some trouble happens.
   It is recommended in case of taking several campaigns consecutive, as in the case of measuring on each line of lemon trees that, if you introduce manually configuration data into 
   the Anritsu and it doesn´t match the data introduced manually; that data will obviously exchange for the data introduced in the GUI when the “Connect buttom” is clicked._

## Authors ✒️

* **David Párraga** - *Development* - [davidParraga](https://github.com/davidParraga)

## License 📄

These files are not licensed

---
⌨️ with ❤️ by [davidParraga](https://github.com/davidParraga)
