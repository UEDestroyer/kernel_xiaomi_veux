// SPDX-License-Identifier: GPL-2.0

#include <linux/module.h>
#include <linux/platform_device.h>
#include <linux/remoteproc.h>

static int fw_rproc_start(struct rproc *rproc)
{
    return 0;
}

static int fw_rproc_stop(struct rproc *rproc)
{
    return 0;
}

static void fw_rproc_kick(struct rproc *rproc, int vqid)
{
}

static const struct rproc_ops fw_rproc_ops = {
    .start = fw_rproc_start,
    .stop  = fw_rproc_stop,
    .kick  = fw_rproc_kick,
};

static int fw_rproc_probe(struct platform_device *pdev)
{
    struct rproc *rproc;
    int ret;

    rproc = rproc_alloc(
            &pdev->dev,
            "modem",
            &fw_rproc_ops,
            NULL,
            0);

    if (!rproc)
        return -ENOMEM;

    rproc->auto_boot = false;

    ret = rproc_add(rproc);
    if (ret) {
        rproc_free(rproc);
        return ret;
    }

    platform_set_drvdata(pdev, rproc);

    dev_info(&pdev->dev, "fake remoteproc registered\n");

    return 0;
}

static int fw_rproc_remove(struct platform_device *pdev)
{
    struct rproc *rproc = platform_get_drvdata(pdev);

    rproc_del(rproc);
    rproc_free(rproc);

    return 0;
}

static const struct of_device_id fw_rproc_match[] = {
    { .compatible = "firmware,remoteproc" },
    { }
};
MODULE_DEVICE_TABLE(of, fw_rproc_match);

static struct platform_driver fw_rproc_driver = {
    .probe  = fw_rproc_probe,
    .remove = fw_rproc_remove,
    .driver = {
        .name = "firmware_remoteproc",
        .of_match_table = fw_rproc_match,
    },
};

module_platform_driver(fw_rproc_driver);

MODULE_LICENSE("GPL");
