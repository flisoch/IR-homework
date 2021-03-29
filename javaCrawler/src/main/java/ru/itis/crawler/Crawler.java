package ru.itis.crawler;

import org.apache.commons.io.FileUtils;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;

import java.io.File;
import java.io.IOException;
import java.util.Scanner;

public class Crawler {
    private final File indexFileName = new File("resources/index.txt");
    private final File linksFileName = new File("resources/links.txt");

    public void start() {
        try {
            Scanner scanner = new Scanner(linksFileName);
            String path = "resources/files/";
            int i = 0;
            while (scanner.hasNextLine()) {
                String link = scanner.nextLine();
                Document document = Jsoup.connect(link).get();
                File fileName = new File(path + i + ".txt");
                savePageText(document.text(), fileName);
                saveToIndex(i, link);
                i++;
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void savePageText(String text, File fileName) {
        try {
            FileUtils.writeStringToFile(fileName, text, true);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


    private void saveToIndex(int docNumber, String link) {
        String fileIndexName = String.format("%d %s\n", docNumber, link);
        try {
            FileUtils.writeStringToFile(indexFileName, fileIndexName, true);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

}