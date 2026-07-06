package com.github.kr328.clash.design.adapter

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.LinearLayout
import android.widget.TextView
import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.RecyclerView
import com.github.kr328.clash.design.R
import com.github.kr328.clash.network.PlanData

class PlanDataAdapter(
    private val onItemClick: (plan: PlanData, period: String) -> Unit
) : RecyclerView.Adapter<SubscriptionViewHolder>() {

    private val subscriptions = mutableListOf<PlanData>()

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): SubscriptionViewHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.activity_item_subscription, parent, false)
        return SubscriptionViewHolder(view)
    }

    override fun onBindViewHolder(holder: SubscriptionViewHolder, position: Int) {
        val subscription = subscriptions[position]
        holder.bind(subscription, onItemClick)
    }

    override fun getItemCount(): Int {
        return subscriptions.size
    }

    @SuppressLint("NotifyDataSetChanged")
    fun setData(newData: List<PlanData>) {
        subscriptions.clear()
        subscriptions.addAll(newData)
        notifyDataSetChanged()
    }

    @SuppressLint("NotifyDataSetChanged")
    fun addData(newData: List<PlanData>) {
        subscriptions.addAll(newData)
        notifyDataSetChanged()
    }
}

class SubscriptionViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {

    private val planName: TextView = itemView.findViewById(R.id.subscriptionName)
    private val planDescription: TextView = itemView.findViewById(R.id.subscriptionDescription)
    private val planPrice: TextView = itemView.findViewById(R.id.subscriptionPrice)
    private val planPriceUnit: TextView = itemView.findViewById(R.id.subscriptionPriceUnit)

    private val layoutMonth: LinearLayout = itemView.findViewById(R.id.layout_month)
    private val layoutQuarter: LinearLayout = itemView.findViewById(R.id.layout_quarter)
    private val layoutHalfYear: LinearLayout = itemView.findViewById(R.id.layout_half_year)
    private val layoutYear: LinearLayout = itemView.findViewById(R.id.layout_year)

    private val textMonthPrice: TextView = itemView.findViewById(R.id.text_month_price)
    private val textQuarterPrice: TextView = itemView.findViewById(R.id.text_quarter_price)
    private val textHalfYearPrice: TextView = itemView.findViewById(R.id.text_half_year_price)
    private val textYearPrice: TextView = itemView.findViewById(R.id.text_year_price)

    private var selectedPeriod: String = "month_price"
    private var currentPlan: PlanData? = null
    private var onItemClickCallback: ((plan: PlanData, period: String) -> Unit)? = null

    @SuppressLint("SetTextI18n")
    fun bind(data: PlanData, onItemClick: (plan: PlanData, period: String) -> Unit) {
        currentPlan = data
        onItemClickCallback = onItemClick

        // 设置套餐名称和流量
        planName.text = data.name
        planDescription.text = "${data.transfer_enable ?: 0}GB"

        // 计算价格（分转元）
        val monthPrice = (data.month_price ?: 0).toDouble() / 100
        val quarterPrice = (data.quarter_price ?: 0).toDouble() / 100
        val halfYearPrice = (data.half_year_price ?: 0).toDouble() / 100
        val yearPrice = (data.year_price ?: 0).toDouble() / 100

        // 显示最低价格
        val minPrice = when {
            monthPrice > 0 -> monthPrice
            quarterPrice > 0 -> quarterPrice / 3
            halfYearPrice > 0 -> halfYearPrice / 6
            yearPrice > 0 -> yearPrice / 12
            else -> 0.0
        }
        planPrice.text = "¥${String.format("%.0f", minPrice)}"

        // 一次性付费
        if (data.onetime_price != null && data.onetime_price > 0) {
            val onetimePrice = data.onetime_price.toDouble() / 100
            planPrice.text = "¥${String.format("%.0f", onetimePrice)}"
            planPriceUnit.text = "一次性"

            layoutMonth.visibility = View.GONE
            layoutQuarter.visibility = View.GONE
            layoutHalfYear.visibility = View.GONE
            layoutYear.visibility = View.GONE

            selectedPeriod = "onetime_price"
        } else {
            planPriceUnit.text = "起/月"

            // 月付
            if (monthPrice > 0) {
                layoutMonth.visibility = View.VISIBLE
                textMonthPrice.text = "¥${String.format("%.0f", monthPrice)}"
            } else {
                layoutMonth.visibility = View.GONE
            }

            // 季付
            if (quarterPrice > 0) {
                layoutQuarter.visibility = View.VISIBLE
                textQuarterPrice.text = "¥${String.format("%.0f", quarterPrice)}"
            } else {
                layoutQuarter.visibility = View.GONE
            }

            // 半年付
            if (halfYearPrice > 0) {
                layoutHalfYear.visibility = View.VISIBLE
                textHalfYearPrice.text = "¥${String.format("%.0f", halfYearPrice)}"
            } else {
                layoutHalfYear.visibility = View.GONE
            }

            // 年付
            if (yearPrice > 0) {
                layoutYear.visibility = View.VISIBLE
                textYearPrice.text = "¥${String.format("%.0f", yearPrice)}"
            } else {
                layoutYear.visibility = View.GONE
            }

            // 默认选中月付
            selectedPeriod = "month_price"
            updateSelectedStyle()
        }

        // 价格选项点击事件
        layoutMonth.setOnClickListener {
            if (monthPrice > 0) {
                selectedPeriod = "month_price"
                updateSelectedStyle()
                onItemClickCallback?.invoke(data, selectedPeriod)
            }
        }

        layoutQuarter.setOnClickListener {
            if (quarterPrice > 0) {
                selectedPeriod = "quarter_price"
                updateSelectedStyle()
                onItemClickCallback?.invoke(data, selectedPeriod)
            }
        }

        layoutHalfYear.setOnClickListener {
            if (halfYearPrice > 0) {
                selectedPeriod = "half_year_price"
                updateSelectedStyle()
                onItemClickCallback?.invoke(data, selectedPeriod)
            }
        }

        layoutYear.setOnClickListener {
            if (yearPrice > 0) {
                selectedPeriod = "year_price"
                updateSelectedStyle()
                onItemClickCallback?.invoke(data, selectedPeriod)
            }
        }

        // 整个卡片点击事件 - 使用当前选中的周期
        itemView.findViewById<View>(R.id.plan_card_root).setOnClickListener {
            onItemClickCallback?.invoke(data, selectedPeriod)
        }
    }

    private fun updateSelectedStyle() {
        val selectedBg = ContextCompat.getDrawable(itemView.context, R.drawable.price_item_selected_bg)
        val normalBg = ContextCompat.getDrawable(itemView.context, R.drawable.price_item_bg)

        layoutMonth.background = if (selectedPeriod == "month_price") selectedBg else normalBg
        layoutQuarter.background = if (selectedPeriod == "quarter_price") selectedBg else normalBg
        layoutHalfYear.background = if (selectedPeriod == "half_year_price") selectedBg else normalBg
        layoutYear.background = if (selectedPeriod == "year_price") selectedBg else normalBg
    }
}
