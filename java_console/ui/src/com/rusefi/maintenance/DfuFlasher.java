package com.rusefi.maintenance;

import com.rusefi.FileLog;
import com.rusefi.Launcher;
import com.rusefi.Timeouts;
import com.rusefi.autodetect.PortDetector;
import com.rusefi.binaryprotocol.BinaryProtocol;
import com.rusefi.config.generated.Fields;
import com.rusefi.io.IoStream;
import com.rusefi.io.serial.PortHolder;
import com.rusefi.io.serial.SerialIoStreamJSerialComm;
import com.rusefi.ui.StatusWindow;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.io.IOException;

/**
 * @see FirmwareFlasher
 */
public class DfuFlasher {
    public static final String DFU_BINARY = Launcher.TOOLS_PATH + File.separator + "DfuSe/DfuSeCommand.exe";
    // TODO: integration with DFU command line tool
    static final String DFU_COMMAND = DFU_BINARY + " -c -d --v --fn " + Launcher.INPUT_FILES_PATH + File.separator +
            "rusefi.dfu";

    private final JButton button = new JButton("Program via DFU");

    public DfuFlasher(JComboBox<String> comboPorts) {
        button.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent event) {
                String port = comboPorts.getSelectedItem().toString();
                port = PortDetector.autoDetectSerialIfNeeded(port);
                if (port == null)
                    return;
                IoStream stream = SerialIoStreamJSerialComm.open(port, PortHolder.BAUD_RATE, FileLog.LOGGER);
                byte[] command = BinaryProtocol.getTextCommandBytes(Fields.CMD_REBOOT_DFU);
                try {
                    stream.sendPacket(command, FileLog.LOGGER);
                    stream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }

                StatusWindow wnd = new StatusWindow();
                wnd.showFrame("DFU status");
                ExecHelper.submitAction(() -> executeDFU(wnd), getClass() + " thread");
            }
        });
    }

    private void executeDFU(StatusWindow wnd) {
        wnd.appendMsg("Giving time for USB enumeration...");
        try {
            Thread.sleep(3 * Timeouts.SECOND);
        } catch (InterruptedException e) {
            throw new IllegalStateException(e);
        }
        ExecHelper.executeCommand(FirmwareFlasher.BINARY_LOCATION,
                FirmwareFlasher.BINARY_LOCATION + File.separator + DFU_COMMAND,
                DFU_BINARY, wnd);
        wnd.appendMsg("Please power cycle device to exit DFU mode");
    }

    public Component getButton() {
        return button;
    }
}
